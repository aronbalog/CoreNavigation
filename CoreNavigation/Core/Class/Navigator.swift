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
                func passData() {
                    var dataPassingCandidates: [Any?] = [
                        configuration.protection,
                        configuration.to,
                        configuration.embeddable,
                        viewController
                    ]
                    
                    if let embeddingViewController = embeddingViewController {
                        dataPassingCandidates.append(embeddingViewController)
                    }
                    
                    self.passData(configuration.dataToPass, to: dataPassingCandidates)
                }
                
                passData()
                let destinationViewController = embeddingViewController ?? viewController
                let result = self.doOnNavigationSuccess(viewController: viewController, configuration: configuration)

                configuration.sourceViewController.present(destinationViewController, animated: configuration.isAnimated, completion: {
                    self.resultCompletion(with: result, configuration: configuration)
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
        fatalError()
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
    
    func doOnNavigationSuccess<DestinationType: Destination, FromType: UIViewController>(viewController: DestinationType.ViewControllerType, configuration: Configuration<DestinationType, FromType>) -> Result<DestinationType, FromType> {
        let result = Result<DestinationType, FromType>(toViewController: viewController, fromViewController: configuration.sourceViewController)
        
        configuration.onSuccessBlocks.forEach { $0(result) }
        
        return result
    }
    
    func resultCompletion<DestinationType: Destination, FromType: UIViewController>(with result: Result<DestinationType, FromType>, configuration: Configuration<DestinationType, FromType>) {
        configuration.onCompletionBlocks.forEach { $0(result) }
    }
    
    func viewControllerToNavigateTo<DestinationType: Destination, FromType: UIViewController>(with configuration: Configuration<DestinationType, FromType>, onComplete: @escaping (DestinationType.ViewControllerType, UIViewController?) -> Void, onCancel: @escaping (Error?) -> Void) {
        configuration.to.resolve(with: Resolver<DestinationType>(onCompleteBlock: { viewController in
            guard let embeddable = configuration.embeddable else {
                onComplete(viewController, nil)
                return
            }
            
            do {
                let context = Embedding.Context(rootViewController: viewController, onComplete: { (embeddingViewController) in
                    onComplete(viewController, embeddingViewController)
                }, onCancel: onCancel)
                try embeddable.embed(with: context)
            } catch let error {
                onCancel(error)
            }
        }, onCancelBlock: onCancel))
    }
    
    func passData(_ dataType: DataPassing.Strategy?, to potentialDataReceivables: [Any?]) {
        guard
            let dataType = dataType
        else { return }
        
        let potentialDataReceivables = potentialDataReceivables.compactMap { $0 as? AnyDataReceivable }

        potentialDataReceivables.forEach { (dataReceivable) in
            queue.sync {
                switch dataType {
                case .sync(let data):
                    dataReceivable.didReceiveAnyData(data)
                case .async(let block):
                    block(DataPassing.Context(onPassData: dataReceivable.didReceiveAnyData))
                }
            }
        }
    }
}
