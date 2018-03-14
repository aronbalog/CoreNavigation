import Foundation

extension Navigator {
    static func push<T>(_ viewController: UIViewController, with configuration: Configuration<T>, completion: @escaping () -> Void)  {
        let animated = configuration.transitioning.animated

        DispatchQueue.main.async {
            let navigationController = UIViewController.currentViewController?.navigationController
            let transitioningCompletionBlocks = configuration.transitioning.completionBlocks
            let eventBlocks: [() -> Void] = configuration.events.navigationEvents.flatMap({ (event) -> (() -> Void)? in
                if case NavigationEvent.completion(let block) = event {
                    return block
                }
                
                return nil
            })
            
            configuration.willNavigateBlocks.forEach({ (block) in
                block(viewController)
            })
//            
//            let item = History.Item(viewController: viewController,
//                                    navigationType: .push,
//                                    configuration: configuration)
//            History.shared.add(item)
            
            navigationController?.pushViewController(viewController, animated: animated, completion: {
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
