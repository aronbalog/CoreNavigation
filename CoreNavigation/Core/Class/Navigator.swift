class Navigator {
    let queue: DispatchQueue
    let cache: Caching.Cache
    
    init(queue: DispatchQueue, cache: Caching.Cache) {
        initFramework
        
        self.queue = queue
        self.cache = cache
    }
    
    func navigate<DestinationType: Destination, FromType: UIViewController>(with configuration: Configuration<DestinationType, FromType>) {
        protectNavigation(configuration: configuration, onAllow: {
            switch configuration.directive {
            case .direction(let direction):
                switch direction {
                case .forward(let forward):
                    switch forward {
                    case .present: self.present(with: configuration)
                    case .push: self.push(with: configuration)
                    case .childViewController: self.childViewController(with: configuration)
                    }
                case .backward(let backward):
                    switch backward {
                    case .dismiss: self.dismiss(with: configuration)
                    case .pop: fatalError()
                    }
                }
            case .none: break
            }
        }) { (error) in
            self.resultFailure(with: error, configuration: configuration)
        }
    }
    
    private func dismiss<DestinationType: Destination, FromType: UIViewController>(with configuration: Configuration<DestinationType, FromType>) {
        queue.sync {
            let sourceViewController = configuration.sourceViewController as! DestinationType.ViewControllerType
            
            let result = self.doOnNavigationSuccess(destination: configuration.destination, viewController: sourceViewController, configuration: configuration)
            
            DispatchQueue.main.async {
                sourceViewController.dismiss(animated: configuration.isAnimatedBlock(), completion: {
                    self.resultCompletion(with: result, configuration: configuration)
                })
            }
        }
    }
    
    private func present<DestinationType: Destination, FromType: UIViewController>(
        with configuration: Configuration<DestinationType, FromType>)
    {
        queue.sync {
            viewControllerToNavigateTo(with: configuration, onComplete: { destination, viewController, embeddingViewController in
                let dataPassingCandidates: [Any?] =
                    configuration.protections +
                        [
                            destination,
                            configuration.embeddable,
                            viewController,
                            embeddingViewController
                ]
                
                self.passData(configuration.dataPassingBlock, to: dataPassingCandidates)
                
                let destinationViewController = embeddingViewController ?? viewController
                let result = self.doOnNavigationSuccess(destination: destination, viewController: viewController, configuration: configuration)
                var transitioningDelegate = configuration.transitioningDelegateBlock?()
                
                DispatchQueue.main.async {
                    destinationViewController.transitioningDelegate = transitioningDelegate
                    configuration.sourceViewController.present(destinationViewController, animated: configuration.isAnimatedBlock(), completion: {
                        self.resultCompletion(with: result, configuration: configuration)
                        transitioningDelegate = nil
                    })
                }
            }, onCancel: { error in
                self.resultFailure(with: error, configuration: configuration)
            })
        }
    }
    
    private func push<DestinationType: Destination, FromType: UIViewController>(
        with configuration: Configuration<DestinationType, FromType>)
    {
        queue.sync {
            viewControllerToNavigateTo(with: configuration, onComplete: { (destination, viewController, embeddingViewController) in
                let navigationController: UINavigationController? = {
                    return configuration.sourceViewController.navigationController ?? configuration.sourceViewController as? UINavigationController
                }()
                
                let dataPassingCandidates: [Any?] =
                    configuration.protections +
                        [
                            destination,
                            configuration.embeddable,
                            viewController,
                            embeddingViewController
                ]
                
                self.passData(configuration.dataPassingBlock, to: dataPassingCandidates)
                
                let destinationViewController = embeddingViewController ?? viewController
                let result = self.doOnNavigationSuccess(destination: destination, viewController: viewController, configuration: configuration)
                var transitioningDelegate = configuration.transitioningDelegateBlock?()

                DispatchQueue.main.async {
                    navigationController?.transitioningDelegate = transitioningDelegate
                    
                    navigationController?.pushViewController(destinationViewController, animated: configuration.isAnimatedBlock(), completion: {
                        self.resultCompletion(with: result, configuration: configuration)
                        transitioningDelegate = nil
                    })
                }
            }, onCancel: { (error) in
                self.resultFailure(with: error, configuration: configuration)
            })
        }
    }
    
    private func childViewController<DestinationType: Destination, FromType: UIViewController>(
        with configuration: Configuration<DestinationType, FromType>)
    {
        queue.sync {
            viewControllerToNavigateTo(with: configuration, onComplete: { (destination, viewController, embeddingViewController) in
                let dataPassingCandidates: [Any?] =
                    configuration.protections +
                        [
                            destination,
                            configuration.embeddable,
                            viewController,
                            embeddingViewController
                ]
                
                self.passData(configuration.dataPassingBlock, to: dataPassingCandidates)
                let destinationViewController = embeddingViewController ?? viewController
                let result = self.doOnNavigationSuccess(destination: destination, viewController: viewController, configuration: configuration)
                let sourceViewController = configuration.sourceViewController
                
                DispatchQueue.main.async {
                    sourceViewController.addChild(destinationViewController)
                    destinationViewController.view.frame = sourceViewController.view.bounds
                    sourceViewController.view.addSubview(destinationViewController.view)
                    destinationViewController.didMove(toParent: sourceViewController)
                }
                
                self.resultCompletion(with: result, configuration: configuration)
            }, onCancel: { (error) in                
                configuration.onFailureBlocks.forEach({ (block) in
                    block(error)
                })
            })
        }
    }
    
    private func protectNavigation<DestinationType: Destination, FromType: UIViewController>(
        configuration: Configuration<DestinationType, FromType>,
        onAllow: @escaping () -> Void,
        onDisallow: @escaping (Error) -> Void)
    {
        func handleProtection(with protectable: Protectable, onAllow: @escaping () -> Void, onDisallow: @escaping (Error) -> Void) {
            do {
                try protectable.protect(with: Protection.Context(onAllow: onAllow, onDisallow: onDisallow))
            } catch let error {
                onDisallow(error)
            }
        }
        
        if !configuration.protections.isEmpty {            
            handleProtection(with: Protection.Chain(protectables: configuration.protections), onAllow: onAllow, onDisallow: onDisallow)
        } else if let protectable = configuration.destination as? Protectable {
            handleProtection(with: protectable, onAllow: onAllow, onDisallow: onDisallow)
        } else if let protectable = configuration.embeddable as? Protectable {
            handleProtection(with: protectable, onAllow: onAllow, onDisallow: onDisallow)
        } else {
            onAllow()
        }
    }
    
    private func doOnNavigationSuccess<DestinationType: Destination, FromType: UIViewController>(
        destination: DestinationType,
        viewController: DestinationType.ViewControllerType,
        configuration: Configuration<DestinationType, FromType>) -> Navigation.Result<DestinationType, FromType>
    {
        let result = Navigation.Result<DestinationType, FromType>(destination: destination, toViewController: viewController, fromViewController: configuration.sourceViewController)
        
        configuration.onSuccessBlocks.forEach { $0(result) }
        
        return result
    }
    
    private func resultFailure<DestinationType: Destination, FromType: UIViewController>(
        with error: Error,
        configuration: Configuration<DestinationType, FromType>)
    {
        configuration.onFailureBlocks.forEach { $0(error) }
    }
    
    private func resultCompletion<DestinationType: Destination, FromType: UIViewController>(
        with result: Navigation.Result<DestinationType, FromType>,
        configuration: Configuration<DestinationType, FromType>)
    {
        configuration.onCompletionBlocks.forEach { $0(result) }
    }
    
    func viewControllerToNavigateTo<DestinationType: Destination, FromType: UIViewController>(
        with configuration: Configuration<DestinationType, FromType>,
        onComplete: @escaping (DestinationType, DestinationType.ViewControllerType, UIViewController?) -> Void,
        onCancel: @escaping (Error) -> Void)
    {
        let caching = configuration.cachingBlock?()
        let destination = configuration.destination
        
        func resolveNew() {
            resolve(destination, embeddable: configuration.embeddable, onComplete: { destination, viewController, embeddingViewController in
                if let caching = caching {
                    self.cache(cacheIdentifier: caching.0, cacheable: caching.1, viewController: viewController, embeddingViewController: embeddingViewController)
                }
                
                configuration.viewControllerEventBlocks.forEach({ (block) in
                    self.bindEvents(to: viewController, navigationEvents: block())
                })
                
                onComplete(destination, viewController, embeddingViewController)
            }, onCancel: onCancel)
        }
        
        if let caching = caching {
            resolveFromCache(destination, cacheIdentifier: caching.0, success: onComplete, failure: resolveNew)
        } else {
            resolveNew()
        }
    }
    
    private func bindEvents<ViewControllerType: UIViewController>(to viewController: ViewControllerType, navigationEvents: [UIViewController.Event<ViewControllerType>]) {
        let viewControllerEvents = UIViewController.Observer()
        
        navigationEvents.forEach { (event) in
            switch event {
            case .loadView(let block):
                viewControllerEvents.onLoadView { block($0 as! ViewControllerType) }
            case .viewDidLoad(let block):
                viewControllerEvents.onViewDidLoad { block($0 as! ViewControllerType) }
            case .viewWillAppear(let block):
                viewControllerEvents.onViewWillAppear { block($0 as! ViewControllerType, $1) }
            case .viewDidAppear(let block):
                viewControllerEvents.onViewDidAppear { block($0 as! ViewControllerType, $1) }
            case .viewWillDisappear(let block):
                viewControllerEvents.onViewWillDisappear { block($0 as! ViewControllerType, $1) }
            case .viewDidDisappear(let block):
                viewControllerEvents.onViewDidDisappear { block($0 as! ViewControllerType, $1) }
            case .viewWillTransition(let block):
                viewControllerEvents.onViewWillTransition { block($0 as! ViewControllerType, $1, $2) }
            case .viewWillLayoutSubviews(let block):
                viewControllerEvents.onViewWillLayoutSubviews { block($0 as! ViewControllerType) }
            case .viewDidLayoutSubviews(let block):
                viewControllerEvents.onViewDidLayoutSubviews { block($0 as! ViewControllerType) }
            case .viewLayoutMarginsDidChange(let block):
                viewControllerEvents.onViewLayoutMarginsDidChange { block($0 as! ViewControllerType) }
            case .viewSafeAreaInsetsDidChange(let block):
                viewControllerEvents.onViewSafeAreaInsetsDidChange { block($0 as! ViewControllerType) }
            case .updateViewConstraints(let block):
                viewControllerEvents.onUpdateViewConstraints { block($0 as! ViewControllerType) }
            case .willMoveTo(let block):
                viewControllerEvents.onWillMoveTo { block($0 as! ViewControllerType, $1) }
            case .didMoveTo(let block):
                viewControllerEvents.onDidMoveTo { block($0 as! ViewControllerType, $1) }
            case .didReceiveMemoryWarning(let block):
                viewControllerEvents.onDidReceiveMemoryWarning { block($0 as! ViewControllerType) }
            case .applicationFinishedRestoringState(let block):
                viewControllerEvents.onApplicationFinishedRestoringState { block($0 as! ViewControllerType) }
            }
        }
        
        viewController.events = viewControllerEvents
        
    }
    
    private func resolve<DestinationType: Destination>(
        _ destination: DestinationType,
        embeddable: Embeddable?,
        onComplete: @escaping (DestinationType, DestinationType.ViewControllerType, UIViewController?) -> Void,
        onCancel: @escaping (Error) -> Void)
    {
        destination.resolve(with: Resolver<DestinationType>(onCompleteBlock: { viewController in
            guard let embeddable = embeddable else {
                onComplete(destination, viewController, nil)
                return
            }
            
            do {
                try embeddable.embed(with: Embedding.Context(rootViewController: viewController, onComplete: { (embeddingViewController) in
                    onComplete(destination, viewController, embeddingViewController)
                }, onCancel: onCancel))
            } catch let error {
                onCancel(error)
            }
        }, onCancelBlock: onCancel))
    }
    
    private func resolveFromCache<DestinationType: Destination>(
        _ destination: DestinationType,
        cacheIdentifier: String,
        success: @escaping (DestinationType, DestinationType.ViewControllerType, UIViewController?) -> Void,
        failure: @escaping () -> Void)
    {
        guard
            let items = self.cache.find(with: cacheIdentifier),
            let destinationViewController = items.0 as? DestinationType.ViewControllerType
        else {
            failure()
            return
        }
        
        success(destination, destinationViewController, items.1)
    }
    
    private func cache(
        cacheIdentifier: String,
        cacheable: Cacheable,
        viewController: UIViewController,
        embeddingViewController: UIViewController?)
    {
        queue.sync {
            self.cache.addItem(with: cacheIdentifier, viewController: viewController, embeddingViewController: embeddingViewController)
        }

        cacheable.didCache(with: Caching.Context(cacheIdentifier: cacheIdentifier, onInvalidateBlock: {
            self.queue.sync {
                self.cache.removeItem(with: cacheIdentifier)
            }
        }))
    }
    
    private func passData(
        _ block: ((DataPassing.Context<Any>) -> Void)?,
        to potentialDataReceivables: [Any?])
    {
        guard
            let block = block
        else { return }
        
        let potentialDataReceivables = potentialDataReceivables.compactMap { $0 as? AnyDataReceivable }

        potentialDataReceivables.forEach { (dataReceivable) in
            queue.sync {
                block(DataPassing.Context<Any>(onPassData: { data in
                    self.queue.sync {
                        dataReceivable.didReceiveAnyData(data)
                    }
                }))
            }
        }
    }
}
