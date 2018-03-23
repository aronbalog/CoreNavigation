import Foundation

extension Navigator {
    static func push<T>(_ viewController: UIViewController, with configuration: Configuration<T>, completion: @escaping () -> Void)  {
        let animated = configuration.transitioning.animated
        let viewControllerTransitioningDelegate = configuration.transitioning.viewControllerTransitioningDelegate
        
        DispatchQueue.main.async {
            let currentViewController = UIViewController.currentViewController(in: configuration.application.application)
            
            let navigationController = currentViewController?.navigationController
            
            navigationController?.transitioningDelegate = viewControllerTransitioningDelegate
            
            let transitioningCompletionBlocks = configuration.transitioning.completionBlocks
            let eventBlocks: [() -> Void] = configuration.events.navigationEvents.flatMap({ (event) -> (() -> Void)? in
                if case Configuration<T>.Events.NavigationEvent.completion(let block) = event {
                    return block
                }
                
                return nil
            })
            
            configuration.willNavigateBlocks.forEach({ (block) in
                block(viewController)
            })
            
            let viewControllerToPush: UIViewController = {
                // pushing navigation controller is not supported
                if case .navigationController? = configuration.embedding.embeddingType {
                    return viewController
                } else {
                    return self.viewControllerToNavigate(viewController, with: configuration)
                }
            }()
            
            let item = History.Item(viewController: viewController,
                                    navigationType: .push,
                                    configuration: configuration)
            History.shared.add(item)
            
            navigationController?.pushViewController(viewControllerToPush, animated: animated, completion: {
                // from transitioning
                transitioningCompletionBlocks.forEach { $0() }
                
                // from events
                eventBlocks.forEach { $0() }
                
                // final
                completion()
            })
        }
    }
}
