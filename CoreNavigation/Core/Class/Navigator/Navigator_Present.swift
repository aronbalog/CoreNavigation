import Foundation

extension Navigator {
    static func present<T>(_ viewController: UIViewController, with configuration: Configuration<T>, completion: @escaping () -> Void) {
        let animated = configuration.transitioning.animated
        let viewControllerTransitioningDelegate = configuration.transitioning.viewControllerTransitioningDelegate

        DispatchQueue.main.async {
            let fromViewController: UIViewController? = {
                if let fromViewController = configuration.originViewController {
                    return fromViewController
                }

                let window = configuration.windowObject.window ?? UIApplication.shared.keyWindow

                return UIViewController.currentViewController(in: window)
            }()

            fromViewController?.transitioningDelegate = viewControllerTransitioningDelegate

            let transitioningCompletionBlocks = configuration.transitioning.completionBlocks
            let eventBlocks: [() -> Void] = configuration.events.navigationEvents.flatMap({ (event) -> (() -> Void)? in
                if case Configuration<T>.Events.NavigationEvent.completion(let block) = event {
                    return block
                }

                return nil
            })

            let viewControllerToPresent = self.viewControllerToNavigate(viewController, with: configuration)

            let item = History.Item(viewController: viewControllerToPresent,
                                    navigationType: .present,
                                    configuration: configuration)
            History.shared.add(item)

            fromViewController?.present(viewControllerToPresent, animated: animated, completion: {
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
