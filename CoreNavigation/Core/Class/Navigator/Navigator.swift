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
            switch configuration.destination {
            case .viewController(let viewController):
                bindEvents(to: viewController, with: configuration)
                
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
            case .routePath(let routePath):
                ()
            case .viewControllerBlock(let block):
                block { viewController in
                    bindEvents(to: viewController, with: configuration)
                    
                    switch type {
                    case .push:
                        push(viewController, with: configuration, completion: {
                            handler()
                        })
                    case .present:
                        print("Executing operation block")

                        present(viewController, with: configuration, completion: {
                            handler()
                        })
                    }
                    
                }
            case .viewControllerClassBlock(let block):
                block { viewControllerClass in
                    let viewController = viewControllerClass.init(nibName: nil, bundle: nil)
                    bindEvents(to: viewController, with: configuration)
                    
                    switch type {
                    case .push:
                        push(viewController, with: configuration, completion: {
                            handler()
                        })
                    case .present:
                        print("Executing operation block")
                        
                        present(viewController, with: configuration, completion: {
                            handler()
                        })
                    }
                    
                }
            case .unknown:
                ()
            }
            
            completion?()
        })
        print("Added operation")
        queue.addOperation(operation)
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
    
    private static func bindEvents<T>(to viewController: UIViewController, with configuration: Configuration<T>) {
        let viewControllerEvents = ViewControllerObserver()
        
        configuration.events.navigationEvents.forEach { (event) in
            switch event {
            case .viewControllerEvent(let viewControllerEvent):
                switch viewControllerEvent {
                case .loadView(let block): viewControllerEvents.onLoadView(block)
                case .viewDidLoad(let block): viewControllerEvents.onViewDidLoad(block)
                case .viewWillAppear(let block): viewControllerEvents.onViewWillAppear(block)
                case .viewDidAppear(let block): viewControllerEvents.onViewDidAppear(block)
                case .viewWillDisappear(let block): viewControllerEvents.onViewWillDisappear(block)
                case .viewDidDisappear(let block): viewControllerEvents.onViewDidDisappear(block)
                case .viewWillTransition(let block): viewControllerEvents.onViewWillTransition(block)
                case .viewWillLayoutSubviews(let block): viewControllerEvents.onViewWillLayoutSubviews(block)
                case .viewDidLayoutSubviews(let block): viewControllerEvents.onViewDidLayoutSubviews(block)
                case .viewLayoutMarginsDidChange(let block): viewControllerEvents.onViewLayoutMarginsDidChange(block)
                case .viewSafeAreaInsetsDidChange(let block): viewControllerEvents.onViewSafeAreaInsetsDidChange(block)
                case .updateViewConstraints(let block): viewControllerEvents.onUpdateViewConstraints(block)
                case .willMoveTo(let block): viewControllerEvents.onWillMoveTo(block)
                case .didMoveTo(let block): viewControllerEvents.onDidMoveTo(block)
                case .didReceiveMemoryWarning(let block): viewControllerEvents.onDidReceiveMemoryWarning(block)
                case .applicationFinishedRestoringState(let block): viewControllerEvents.onApplicationFinishedRestoringState(block)
                }
            default:
                ()
            }
        }
        
        viewController.events = viewControllerEvents
    }
}
