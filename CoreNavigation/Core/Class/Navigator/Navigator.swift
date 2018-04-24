import Foundation
import UIKit

class Navigator {
    static var queue: OperationQueue = {
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()

    static func getViewController<T>(configuration: Configuration<T>, completion: @escaping ((T.ToViewController) -> Void), failure: ((Error) -> Void)? = nil) {
        switch configuration.request {
        case .viewController(let _viewController):
            guard let viewController = _viewController as? T.ToViewController else { break }
            completion(viewController)
        case .viewControllerBlock(let block):
            block { result in
                switch result {
                case .success(let viewController):
                    completion(viewController)
                case .failure(let error):
                    failure?(error)
                }
            }
        case .viewControllerClassBlock(let block):
            block { result in
                switch result {
                case .success(let viewControllerClass):
                    let viewController = viewControllerClass.init()
                    
                    completion(viewController)
                case .failure(let error):
                    failure?(error)
                }
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
                    switch configuration.request {
                    case .viewController(let viewController):
                        action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                    case .viewControllerBlock(let block):
                        block { result in
                            switch result {
                            case .success(let viewController):
                                action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                            case .failure(let error):
                                failure(error: error, configuration: configuration, handler: handler)
                            }
                        }
                    case .viewControllerClassBlock(let block):
                        block { result in
                            switch result {
                            case .success(let viewControllerClass):
                                let viewController = viewControllerClass.init()
                                action(type: type, viewController: viewController, configuration: configuration, handler: handler)
                            case .failure(let error):
                                failure(error: error, configuration: configuration, handler: handler)
                            }
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
        
        let data: T.DataType? = (configuration.dataPassing.data as? T.DataType)
        let result = T.init(toViewController: viewController as! T.ToViewController, data: data)
        
        configuration.successBlocks.forEach { $0(result) }
        
        if let viewController = viewController as? AbstractDataReceivable {
            viewController.didReceiveAbstractData(data)
        }
        
        switch type {
        case .push:
            push(viewController, with: configuration, completion: handler)
        case .present:
            present(viewController, with: configuration, completion: handler)
        }
    }
    
    static func failure<T>(error: Error, configuration: Configuration<T>, handler: @escaping () -> Void) {
        configuration.failureBlocks.forEach { $0(error) }
        
        handler()
    }
    
    static func viewControllerToNavigate<T>(_ viewController: UIViewController, with configuration: Configuration<T>) -> UIViewController {
        return configuration.queue.sync(execute: { () -> UIViewController in
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
        })
    }
}
