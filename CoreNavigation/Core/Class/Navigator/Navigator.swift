import Foundation
import UIKit

class Navigator {
    static var queue: OperationQueue = {
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()

    static func getViewController<T>(configuration: Configuration<T>, completion: @escaping ((T.ToViewController) -> Void)) {
        switch configuration.destination {
        case .viewController(let _viewController):
            guard let viewController = _viewController as? T.ToViewController else { break }
            completion(viewController)
        case .viewControllerBlock(let block):
            block { _viewController in
                
                guard let viewController = _viewController as? T.ToViewController else { return }
                
                completion(viewController)
            }
        case .viewControllerClassBlock(let block):
            block { viewControllerClass in
                guard let viewController = (viewControllerClass as? T.ToViewController.Type)?.init() else { return }

                completion(viewController)
            }
        }
    }
    
    static func navigate<T>(with type: NavigationType, configuration: Configuration<T>, completion: (() -> Void)? = nil) {
        func main(handler: @escaping () -> Void) {
            func navigation() {
                // check if cached
                if
                    let cacheIdentifier = configuration.caching.configuration?.cacheIdentifier,
                    let viewController = Cache.shared.viewController(for: cacheIdentifier)
                {
                    action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                } else {
                    switch configuration.destination {
                    case .viewController(let viewController):
                        action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                    case .viewControllerBlock(let block):
                        block { viewController in
                            action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                        }
                    case .viewControllerClassBlock(let block):
                        block { viewControllerClass in
                            let viewController = viewControllerClass.init()
                            
                            action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                        }
                    }
                }
                
                completion?()
            }
            
            if
                let protectionSpace = configuration.protection.protectionSpace,
                protectionSpace.shouldProtect() == true
            {
                let handler = ProtectionHandler()
                
                handler.onUnprotect {
                    navigation()
                }
                
                protectionSpace.protect(handler)
            } else {
                navigation()
            }
        }
        
        if configuration.unsafeNavigation.isUnsafe {
            main(handler: {})
        } else {
            let operation = NavigationOperation(block: main)
            
            queue.addOperation(operation)
        }
    }
    
    static func action<T>(type: NavigationType, viewController: UIViewController, configuration: Configuration<T>, handler: @escaping () -> Void) {
        bindViewControllerEvents(to: viewController, with: configuration)
        cacheViewControllerIfNeeded(viewController: viewController, with: configuration)
        prepareForStateRestorationIfNeeded(viewController: viewController, with: configuration)
        
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
        
        let viewControllerToNavigate: UIViewController = {
            switch embeddingType {
            case .embeddingProtocol(let aProtocol):
                return aProtocol.embed(viewController)
            case .navigationController:
                return UINavigationController(rootViewController: viewController)
            }
        }()
        
        prepareForStateRestorationIfNeeded(viewController: viewControllerToNavigate, with: configuration)
        
        return viewControllerToNavigate
    }
}
