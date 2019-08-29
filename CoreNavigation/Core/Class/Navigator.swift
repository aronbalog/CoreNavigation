class Navigator {
    let queue: DispatchQueue
    let cache: Caching.Cache
    
    init(queue: DispatchQueue, cache: Caching.Cache) {
        self.queue = queue
        self.cache = cache
    }
    
    func navigate<DestinationType: Destination, FromType: UIViewController>(with configuration: Configuration<DestinationType, FromType>) {
        protectNavigation(configuration: configuration, onAllow: {
            switch configuration.navigationType {
            case .present: self.present(with: configuration)
            case .push: self.push()
            }
        }) { (error) in
            configuration.onFailureBlocks.forEach({ (block) in
                block(error)
            })
        }
    }
    
    private func present<DestinationType: Destination, FromType: UIViewController>(with configuration: Configuration<DestinationType, FromType>) {
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
                let result = self.doOnNavigationSuccess(viewController: viewController, configuration: configuration)

                configuration.sourceViewController.present(destinationViewController, animated: configuration.isAnimatedBlock(), completion: {
                    self.resultCompletion(with: result, configuration: configuration)
                })
            }, onCancel: { error in
                // won't execute failure blocks if no error is returned
                guard let error = error else { return }
                
                configuration.onFailureBlocks.forEach({ (block) in
                    block(error)
                })
            })
        }
    }
    
    private func push() {
        fatalError()
    }
    
    private func protectNavigation<DestinationType: Destination, FromType: UIViewController>(configuration: Configuration<DestinationType, FromType>, onAllow: @escaping () -> Void, onDisallow: @escaping (Error) -> Void) {
        func handleProtection(with protectable: Protectable, onAllow: @escaping () -> Void, onDisallow: @escaping (Error) -> Void) {
            do {
                try protectable.protect(with: Protection.Context(onAllow: onAllow, onDisallow: onDisallow))
            } catch let error {
                onDisallow(error)
            }
        }
        
        if !configuration.protections.isEmpty {            
            handleProtection(with: Protection.Chain(protectables: configuration.protections), onAllow: onAllow, onDisallow: onDisallow)
        } else if let protectable = configuration.toBlock as? Protectable {
            handleProtection(with: protectable, onAllow: onAllow, onDisallow: onDisallow)
        } else if let protectable = configuration.embeddable as? Protectable {
            handleProtection(with: protectable, onAllow: onAllow, onDisallow: onDisallow)
        } else {
            onAllow()
        }
    }
    
    private func doOnNavigationSuccess<DestinationType: Destination, FromType: UIViewController>(viewController: DestinationType.ViewControllerType, configuration: Configuration<DestinationType, FromType>) -> Result<DestinationType, FromType> {
        let result = Result<DestinationType, FromType>(toViewController: viewController, fromViewController: configuration.sourceViewController)
        
        configuration.onSuccessBlocks.forEach { $0(result) }
        
        return result
    }
    
    private func resultCompletion<DestinationType: Destination, FromType: UIViewController>(with result: Result<DestinationType, FromType>, configuration: Configuration<DestinationType, FromType>) {
        configuration.onCompletionBlocks.forEach { $0(result) }
    }
    
    private func viewControllerToNavigateTo<DestinationType: Destination, FromType: UIViewController>(with configuration: Configuration<DestinationType, FromType>, onComplete: @escaping (DestinationType, DestinationType.ViewControllerType, UIViewController?) -> Void, onCancel: @escaping (Error?) -> Void) {
        let caching = configuration.cachingBlock?()
        let destination = configuration.toBlock()
        
        func resolveNew() {
            resolve(destination, embeddable: configuration.embeddable, onComplete: { destination, viewController, embeddingViewController in
                if let caching = caching {
                    self.cache(cacheIdentifier: caching.0, cacheable: caching.1, viewController: viewController, embeddingViewController: embeddingViewController)
                }
                onComplete(destination, viewController, embeddingViewController)
            }, onCancel: onCancel)
        }
        
        if let caching = caching {
            resolveFromCache(destination, cacheIdentifier: caching.0, success: onComplete, failure: resolveNew)
        } else {
            resolveNew()
        }
    }
    
    private func resolve<DestinationType: Destination>(_ destination: DestinationType, embeddable: Embeddable?, onComplete: @escaping (DestinationType, DestinationType.ViewControllerType, UIViewController?) -> Void, onCancel: @escaping (Error?) -> Void) {
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
    
    private func resolveFromCache<DestinationType: Destination>(_ destination: DestinationType, cacheIdentifier: String, success: @escaping (DestinationType, DestinationType.ViewControllerType, UIViewController?) -> Void, failure: @escaping () -> Void) {
        guard
            let items = self.cache.find(with: cacheIdentifier),
            let destinationViewController = items.0 as? DestinationType.ViewControllerType
        else {
            failure()
            return
        }
        
        success(destination, destinationViewController, items.1)
    }
    
    private func cache(cacheIdentifier: String, cacheable: Cacheable, viewController: UIViewController, embeddingViewController: UIViewController?) {
        queue.sync {
            self.cache.addItem(with: cacheIdentifier, viewController: viewController, embeddingViewController: embeddingViewController)
        }

        cacheable.cache(with: Caching.Context(cacheIdentifier: cacheIdentifier, onInvalidateBlock: {
            self.queue.sync {
                self.cache.removeItem(with: cacheIdentifier)
            }
        }))
    }
    
    private func passData(_ block: ((DataPassing.Context<Any>) -> Void)?, to potentialDataReceivables: [Any?]) {
        guard
            let block = block
        else { return }
        
        let potentialDataReceivables = potentialDataReceivables.compactMap { $0 as? AnyDataReceivable }

        potentialDataReceivables.forEach { (dataReceivable) in
            queue.sync {
                block(DataPassing.Context<Any>(onPassData: dataReceivable.didReceiveAnyData))
            }
        }
    }
}
