import Foundation
import UIKit

/// Define destination.
public class To<ResultableType: Resultable>: DestinationAware {
    // MARK: Public
    
    /// Assign view controller to navigate to.
    ///
    /// - Example: Simple navigation to view controller instance.
    ///     ````
    ///     Navigation.present { $0
    ///        .to(UIViewController())
    ///     }
    ///     ````
    ///
    /// - Parameter viewController: A view controller instance.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T>(_ viewController: T) -> Configuration<Result<T, Any>> where T : UIViewController {
        let configuration = Configuration<Result<T, Any>>(destination: .viewController(viewController), from: from)
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign data receivable view controller to navigate to.
    ///
    /// - Example: Simple navigation to view controller instance.
    ///     ````
    ///     let viewController: DataReceivingViewController = ViewController()
    ///
    ///     Navigation.present { $0
    ///        .to(viewController)
    ///     }
    ///     ````
    ///
    /// - Parameter viewController: A view controller instance conforming `DataReceivingViewController` protocol.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivingViewController>(_ viewController: T) -> Configuration<Result<T, T.DataType>> {
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewController(viewController), from: from)
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign view controller class to navigate to.
    ///
    /// - Example: Simple navigation to view controller class.
    ///     ````
    ///     Navigation.present { $0
    ///        .to(UIViewController.self)
    ///     }
    ///     ````
    ///
    /// - Parameter viewControllerClass: A view controller class.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T>(_ viewControllerClass: T.Type) -> Configuration<Result<T, Any>> where T : UIViewController {
        let viewController = viewControllerClass.init()
        let configuration = Configuration<Result<T, Any>>(destination: .viewController(viewController), from: from)
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign data receivable view controller class to navigate to.
    ///
    /// - Example: Simple navigation to view controller instance.
    ///     ````
    ///     let viewControllerClass: DataReceivingViewController.Type = ViewController.self
    ///
    ///     Navigation.present { $0
    ///        .to(viewControllerClass)
    ///     }
    ///     ````
    ///
    /// - Parameter viewControllerClass: A view controller class conforming `DataReceivingViewController` protocol.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivingViewController>(_ viewControllerClass: T.Type) -> Configuration<Result<T, T.DataType>> {
        let viewController = viewControllerClass.init()
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewController(viewController), from: from)
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign block which can be used to resolve view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller instance to this block when navigation is wanted.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T>(_ block: @escaping (@escaping (T) -> Void) -> Void) -> Configuration<Result<T, Any>> where T : UIViewController {
        let viewControllerBlock: (@escaping (Destination<T>.Result) -> Void) -> Void = { resultBlock in
            block { viewController in
                resultBlock(.success(viewController))
            }
        }
        
        let configuration = Configuration<Result<T, Any>>(destination: .viewControllerBlock(viewControllerBlock), from: from)
        
        navigate(with: configuration)

        return configuration
    }
    
    
    /// Assign block which can be used to resolve data receivable view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller instance conforming `DataReceivingViewController` protocol to this block when navigation is wanted.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivingViewController>(_ block: @escaping (@escaping (T) -> Void) -> Void) -> Configuration<Result<T, T.DataType>> {
        let viewControllerBlock: (@escaping (Destination<T>.Result) -> Void) -> Void = { resultBlock in
            block { viewController in
                resultBlock(.success(viewController))
            }
        }
        
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewControllerBlock(viewControllerBlock), from: from)
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign block which can be used to resolve view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller class to this block when navigation is wanted.
    /// - Returns: `Configuration` object
    @discardableResult public func to<T>(_ block: @escaping (@escaping (T.Type) -> Void) -> Void) -> Configuration<Result<T, Any>> where T : UIViewController {
        let viewControllerClassBlock: (@escaping (Destination<T>.Result) -> Void) -> Void = { resultBlock in
            block { viewControllerClass in
                resultBlock(.success(viewControllerClass))
            }
        }
        
        let configuration = Configuration<Result<T, Any>>(destination: .viewControllerClassBlock(viewControllerClassBlock), from: from)

        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign block which can be used to resolve data receivable view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller class conforming `DataReceivingViewController` protocol to this block when navigation is wanted.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivingViewController>(_ block: @escaping (@escaping (T.Type) -> Void) -> Void) -> Configuration<Result<T, T.DataType>> {
        let viewControllerClassBlock: (@escaping (Destination<T>.Result) -> Void) -> Void = { resultBlock in
            block { viewControllerClass in
                resultBlock(.success(viewControllerClass))
            }
        }
        
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewControllerClassBlock(viewControllerClassBlock), from: from)
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign route resolving it's destination to UIViewController class or subclass.
    ///
    /// - Parameter route: Route object resolving it's `Destination` type to `UIViewController` class or subclass.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: Route>(_ route: T) -> Configuration<Result<T.Destination, Any>> {
        let handler = RouteHandler<T>(parameters: route.parameters)

        let configuration = Configuration<Result<T.Destination, Any>>(destination: .viewControllerBlock({ block in
            handler.destinationBlocks.append({ (viewController, data) in
                block(.success(viewController))
            })
            handler.cancelBlocks.append({ (error) in
                block(.failure(error))
            })
        }), from: from)
        
        navigate(with: configuration, completion: {
            type(of: route).route(handler: handler)
        })
        
        return configuration
    }
    
    /// Assign route resolving it's destination to UIViewController class or subclass conforming `DataReceivingViewController` protocol.
    ///
    /// - Parameter route: Route object resolving it's `Destination` type to `UIViewController` class or subclass conforming `DataReceivingViewController` protocol.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: Route>(_ route: T) -> Configuration<Result<T.Destination, T.Destination.DataType>> where T.Destination: DataReceivingViewController {
        let handler = RouteHandler<T>(parameters: route.parameters)

        let configuration = Configuration<Result<T.Destination, T.Destination.DataType>>(destination: .viewControllerBlock({ block in
            handler.destinationBlocks.append({ (viewController, data) in
                block(.success(viewController))
            })
            handler.cancelBlocks.append({ (error) in
                block(.failure(error))
            })
        }), from: from)
        
        navigate(with: configuration, completion: {
            type(of: route).route(handler: handler)
        })
        
        return configuration
    }
    
    /// Assign registered route's URL to navigate to.
    ///
    /// - Parameter url: URL instance.
    /// - Returns: `Configuration` object.
    @discardableResult public func to(_ url: URL) -> Configuration<Result<UIViewController, Any>> {
        return To.to(matchable: url, from: from, action: { configuration in
            navigate(with: configuration)
        })
    }
    
    /// Assign registered route's path to navigate to.
    ///
    /// - Parameter path: String instance
    /// - Returns: `Configuration` object.
    @discardableResult public func to(_ path: String) -> Configuration<Result<UIViewController, Any>> {
        return To.to(matchable: path, from: from, action: { configuration in
            navigate(with: configuration)
        })
    }
    
    /// Assign registered route's uri to navigate to.
    ///
    /// - Parameter matchable: Matchable object.
    /// - Returns: `Configuration` object.
    @discardableResult public func to(_ matchable: Matchable) -> Configuration<Result<UIViewController, Any>> {
        return To.to(matchable: matchable, from: from, action: { configuration in
            navigate(with: configuration)
        })
    }
    
    // MARK: Internal
    
    let navigationType: NavigationType
    var destination: Destination<ResultableType.ToViewController>?
    var from: UIViewController?
    
    init(_ navigationType: NavigationType, from: UIViewController?) {
        self.navigationType = navigationType
        self.from = from
    }
    
    @discardableResult static func to<T>(matchable: Matchable, from: UIViewController?, action: (Configuration<Result<T, Any>>) -> Void) -> Configuration<Result<T, Any>> {
        
        let match = Navigation.router.match(for: matchable)
        
        var _configuration: Configuration<Result<T, Any>>?
        
        let viewControllerBlock: (@escaping (Destination<T>.Result<T>) -> Void) -> Void = { (handler) in
            guard let match = match else {
                // not matched
                handler(.failure(NavigationError.routeNotFound))
                return
            }
            
            let route = match.route
            let parameters = match.parameters
            
            route.route(parameters: parameters, destination: { (destination, data) in
                if let data = data {
                    _configuration?.dataPassing.data = data
                }

                handler(.success(destination as! T))
            }, failure: { error in
                handler(.failure(error ?? NavigationError.unknown))
            })
        }
        
        let configuration = Configuration<Result<T, Any>>(destination: .viewControllerBlock(viewControllerBlock), from: from)
        _configuration = configuration
        
        action(configuration)
        
        return configuration
    }

    // MARK: private
    
    private func navigate<T>(with configuration: Configuration<T>, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            Navigator.navigate(with: self.navigationType, configuration: configuration, completion: completion)
        }
    }
}

