import Foundation
import UIKit

class Navigator {
    static var queue: OperationQueue = {
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()

    static func navigate<T>(with type: NavigationType, configuration: Configuration<T>, completion: (() -> Void)? = nil) {
        let operation = NavigationOperation(block: { handler in

            // check if cached
            if
                let cacheIdentifier = configuration.caching.lifetime?.cacheIdentifier(),
                let viewController = Cache.shared.viewController(for: cacheIdentifier)
            {
                action(type: type, viewController: viewController, configuration: configuration, handler: handler)
            } else {
                switch configuration.destination {
                case .viewController(let viewController):
                    action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                case .routePath(let routePath):
                    ()
                case .viewControllerBlock(let block):
                    block { viewController in
                        action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                    }
                case .viewControllerClassBlock(let block):
                    block { viewControllerClass in
                        let viewController = viewControllerClass.init(nibName: nil, bundle: nil)
                        
                        action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                    }
                case .unknown:
                    ()
                }
            }
            
            completion?()
        })

        queue.addOperation(operation)
    }
    
    static func action<T>(type: NavigationType, viewController: UIViewController, configuration: Configuration<T>, handler: @escaping () -> Void) {
        bindViewControllerEvents(to: viewController, with: configuration)
        cacheIfNeeded(viewController: viewController, with: configuration)
        
        switch type {
        case .push:
            push(viewController, with: configuration, completion: {
                handler()
            })
        case .present:
            present(viewController, with: configuration, completion: {
                handler()
            })
        }
    }
    
    static func viewControllerToNavigate<T>(_ viewController: UIViewController, with configuration: Configuration<T>) -> UIViewController {
        guard let embeddingType = configuration.embedding.embeddingType else {
            return viewController
        }
        
        switch embeddingType {
        case .embeddingProtocol(let aProtocol):
            return aProtocol.embed(viewController)
        case .navigationController:
            return UINavigationController(rootViewController: viewController)
        }
    }
    
    private static func bindViewControllerEvents<T>(to viewController: UIViewController, with configuration: Configuration<T>) {
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
    
    private static func cacheIfNeeded<T>(viewController: UIViewController, with configuration: Configuration<T>) {
        guard let lifetime = configuration.caching.lifetime else { return }
        
        Cache.shared.add(viewController: viewController, lifetime: lifetime)
    }
}
