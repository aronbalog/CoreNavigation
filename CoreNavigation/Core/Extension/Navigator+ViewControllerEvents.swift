import Foundation

extension Navigator {
    static func bindViewControllerEvents<T>(to viewController: UIViewController, with configuration: Configuration<T>) {
        let viewControllerEvents = ViewControllerObserver()

        configuration.events.navigationEvents.forEach { (event) in
            switch event {
            case .viewController(let viewControllerEvent):
                switch viewControllerEvent {
                case .loadView(let block):
                    viewControllerEvents.onLoadView { block($0 as! T.ToViewController) }
                case .viewDidLoad(let block):
                    viewControllerEvents.onViewDidLoad { block($0 as! T.ToViewController) }
                case .viewWillAppear(let block):
                    viewControllerEvents.onViewWillAppear { block($0 as! T.ToViewController, $1) }
                case .viewDidAppear(let block):
                    viewControllerEvents.onViewDidAppear { block($0 as! T.ToViewController, $1) }
                case .viewWillDisappear(let block):
                    viewControllerEvents.onViewWillDisappear { block($0 as! T.ToViewController, $1) }
                case .viewDidDisappear(let block):
                    viewControllerEvents.onViewDidDisappear { block($0 as! T.ToViewController, $1) }
                case .viewWillTransition(let block):
                    viewControllerEvents.onViewWillTransition { block($0 as! T.ToViewController, $1, $2) }
                case .viewWillLayoutSubviews(let block):
                    viewControllerEvents.onViewWillLayoutSubviews { block($0 as! T.ToViewController) }
                case .viewDidLayoutSubviews(let block):
                    viewControllerEvents.onViewDidLayoutSubviews { block($0 as! T.ToViewController) }
                case .viewLayoutMarginsDidChange(let block):
                    viewControllerEvents.onViewLayoutMarginsDidChange { block($0 as! T.ToViewController) }
                case .viewSafeAreaInsetsDidChange(let block):
                    viewControllerEvents.onViewSafeAreaInsetsDidChange { block($0 as! T.ToViewController) }
                case .updateViewConstraints(let block):
                    viewControllerEvents.onUpdateViewConstraints { block($0 as! T.ToViewController) }
                case .willMoveTo(let block):
                    viewControllerEvents.onWillMoveTo { block($0 as! T.ToViewController, $1) }
                case .didMoveTo(let block):
                    viewControllerEvents.onDidMoveTo { block($0 as! T.ToViewController, $1) }
                case .didReceiveMemoryWarning(let block):
                    viewControllerEvents.onDidReceiveMemoryWarning { block($0 as! T.ToViewController) }
                case .applicationFinishedRestoringState(let block):
                    viewControllerEvents.onApplicationFinishedRestoringState { block($0 as! T.ToViewController) }
                }
            default:
                ()
            }
        }

        viewController.events = viewControllerEvents
    }
}
