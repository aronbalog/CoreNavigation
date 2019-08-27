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
    
    func present<DestinationType: Destination, FromType: UIViewController>(with configuration: Configuration<DestinationType, FromType>) {
        queue.sync {
            viewControllerToNavigateTo(with: configuration, onComplete: { viewController, embeddingViewController in
                self.passData(configuration.dataToPass, to: configuration.protection)
                self.passData(configuration.dataToPass, to: configuration.to)
                self.passData(configuration.dataToPass, to: configuration.embeddable)
                self.passData(configuration.dataToPass, to: viewController)
                
                if let embeddingViewController = embeddingViewController {
                    self.passData(configuration.dataToPass, to: embeddingViewController)
                }
                
                let destinationViewController = embeddingViewController ?? viewController
                
                configuration.fromViewController?.present(destinationViewController, animated: configuration.isAnimated, completion: {
                    self.doOnNavigationCompletion(viewController: viewController, configuration: configuration)
                })
            }, onCancel: { error in
                guard let error = error else { return }
                
                configuration.onFailureBlocks.forEach({ (block) in
                    block(error)
                })
            })
        }
    }
    
    func push() {
        
    }
    
    func protectNavigation<DestinationType: Destination, FromType: UIViewController>(configuration: Configuration<DestinationType, FromType>, onAllow: @escaping () -> Void, onDisallow: @escaping (Error) -> Void) {
        func handleProtection(with protectable: Protectable) {
            let handler = ProtectionHandler(onAllow: onAllow, onDisallow: onDisallow)
            do {
                try protectable.protect(handler: handler)
            } catch let error {
                onDisallow(error)
            }
        }
        
        if let protectable = configuration.protection {
            handleProtection(with: protectable)
        } else if let protectable = configuration.to as? Protectable {
            handleProtection(with: protectable)
        } else if let protectable = configuration.embeddable as? Protectable {
            handleProtection(with: protectable)
        } else {
            onAllow()
        }
    }
    
    func doOnNavigationCompletion<DestinationType: Destination, FromType: UIViewController>(viewController: DestinationType.ViewControllerType, configuration: Configuration<DestinationType, FromType>) {
        let result = Result<DestinationType, FromType>(toViewController: viewController, fromViewController: configuration.fromViewController as? FromType)
        
        configuration.onSuccessBlocks.forEach { $0(result) }
    }
    
    func viewControllerToNavigateTo<DestinationType: Destination, FromType: UIViewController>(with configuration: Configuration<DestinationType, FromType>, onComplete: @escaping (DestinationType.ViewControllerType, UIViewController?) -> Void, onCancel: @escaping (Error?) -> Void) {
        guard let to = configuration.to else { return }
        
        let resolver = Resolver<DestinationType>(onCompleteBlock: { viewController in
            guard let embeddable = configuration.embeddable else {
                onComplete(viewController, nil)
                return
            }
            
            do {
                let handler = EmbeddingHandler(onComplete: { (embeddingViewController) in
                    onComplete(viewController, embeddingViewController)
                }, onCancel: onCancel)
                try embeddable.embed(rootViewController: viewController, handler: handler)
            } catch let error {
                onCancel(error)
            }
        }, onCancelBlock: onCancel)
        
        to.resolve(with: resolver)
    }
    
    func passData(_ data: Any?, to potentialDataReceivable: Any?) {
        guard let dataReceivable = potentialDataReceivable as? AnyDataReceivable else { return }
        
        queue.sync {
            dataReceivable.didReceiveAnyData(data)
        }
    }
}
