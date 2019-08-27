class Navigator {
    let queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
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

                configuration.sourceViewController.present(destinationViewController, animated: configuration.isAnimated(), completion: {
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
        } else if let protectable = configuration.to as? Protectable {
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
        resolve(configuration.to(), embeddable: configuration.embeddable, onComplete: onComplete, onCancel: onCancel)
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
    
    private func passData(_ block: ((DataPassing.Context<Any>) -> Void)?, to potentialDataReceivables: [Any?]) {
        guard
            let block = block
        else { return }
        
        let potentialDataReceivables = potentialDataReceivables.compactMap { $0 as? AnyDataReceivable }

        potentialDataReceivables.forEach { (dataReceivable) in
            queue.sync {
                block(DataPassing.Context<Any>(onPassData: dataReceivable.didReceiveAnyData))
//                dataReceivable.didReceiveAnyData()
            }
        }
    }
}
