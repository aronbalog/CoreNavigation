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
        let configuration = Configuration<Result<T, Any>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign data receivable view controller to navigate to.
    ///
    /// - Example: Simple navigation to view controller instance.
    ///     ````
    ///     let viewController: DataReceivable = ViewController()
    ///
    ///     Navigation.present { $0
    ///        .to(viewController)
    ///     }
    ///     ````
    ///
    /// - Parameter viewController: A view controller instance conforming `DataReceivable` protocol.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivable>(_ viewController: T) -> Configuration<Result<T, T.DataType>> {
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewController(viewController))
        
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
        let viewController = viewControllerClass.init(nibName: nil, bundle: nil)
        let configuration = Configuration<Result<T, Any>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign data receivable view controller class to navigate to.
    ///
    /// - Example: Simple navigation to view controller instance.
    ///     ````
    ///     let viewControllerClass: DataReceivable.Type = ViewController.self
    ///
    ///     Navigation.present { $0
    ///        .to(viewControllerClass)
    ///     }
    ///     ````
    ///
    /// - Parameter viewControllerClass: A view controller class conforming `DataReceivable` protocol.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivable>(_ viewControllerClass: T.Type) -> Configuration<Result<T, T.DataType>> {
        let viewController = viewControllerClass.init(nibName: nil, bundle: nil)
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign block which can be used to resolve view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller instance to this block when navigation is wanted.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T>(_ block: @escaping (@escaping (T) -> Void) -> Void) -> Configuration<Result<T, Any>> where T : UIViewController {
        let configuration = Configuration<Result<T, Any>>(destination: .viewControllerBlock(block))
        
        navigate(with: configuration)

        return configuration
    }
    
    
    /// Assign block which can be used to resolve data receivable view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller instance conforming `DataReceivable` protocol to this block when navigation is wanted.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivable>(_ block: @escaping (@escaping (T) -> Void) -> Void) -> Configuration<Result<T, T.DataType>> {
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewControllerBlock(block))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign block which can be used to resolve view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller class to this block when navigation is wanted.
    /// - Returns: `Configuration` object
    @discardableResult public func to<T>(_ block: @escaping (@escaping (T.Type) -> Void) -> Void) -> Configuration<Result<T, Any>> where T : UIViewController {
        let configuration = Configuration<Result<T, Any>>(destination: .viewControllerClassBlock(block))

        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign block which can be used to resolve data receivable view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller class conforming `DataReceivable` protocol to this block when navigation is wanted.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivable>(_ block: @escaping (@escaping (T.Type) -> Void) -> Void) -> Configuration<Result<T, T.DataType>> {
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewControllerClassBlock(block))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    /// Assign route resolving it's destination to UIViewController class or subclass.
    ///
    /// - Parameter route: Route object resolving it's `Destination` type to `UIViewController` class or subclass.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: Route>(_ route: T) -> Configuration<Result<T.Destination, Any>> {
        let handler = RouteHandler<T>(parameters: route.parameters)

        let configuration = Configuration<Result<T.Destination, Any>>(destination: .viewControllerBlock(handler.onDestination))
        
        navigate(with: configuration, completion: {
            type(of: route).route(handler: handler)
        })
        
        return configuration
    }
    
    /// Assign route resolving it's destination to UIViewController class or subclass conforming `DataReceivable` protocol.
    ///
    /// - Parameter route: Route object resolving it's `Destination` type to `UIViewController` class or subclass conforming `DataReceivable` protocol.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: Route>(_ route: T) -> Configuration<Result<T.Destination, T.Destination.DataType>> where T.Destination: DataReceivable {
        let handler = RouteHandler<T>(parameters: route.parameters)

        let configuration = Configuration<Result<T.Destination, T.Destination.DataType>>(destination: .viewControllerBlock(handler.onDestination))
        
        handler.onData({ (data) in
            configuration.dataPassing.data = data
        })
        
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
        return to(matchable: url)
    }
    
    /// Assign registered route's path to navigate to.
    ///
    /// - Parameter path: String instance
    /// - Returns: `Configuration` object
    @discardableResult public func to(_ path: String) -> Configuration<Result<UIViewController, Any>> {
        return to(matchable: path)
    }
    
    // MARK: Internal
    
    let navigationType: NavigationType
    var destination: Destination?
    
    init(_ navigationType: NavigationType) {
        self.navigationType = navigationType
    }
    
    func to(matchable: Matchable) -> Configuration<Result<UIViewController, Any>> {
        
        let match = Navigation.router.match(for: matchable)
        
        var _configuration: Configuration<Result<UIViewController, Any>>?
        
        let viewControllerBlock: (@escaping (UIViewController) -> Void) -> Void = { handler in
            guard let match = match else {
                // not matched
                return
            }
            
            let route = match.route
            let parameters = match.parameters
            
            route.route(parameters: parameters, destination: { (destination) in
                if let viewController = destination as? UIViewController {
                    handler(viewController)
                }
            }, data: { (data) in
                _configuration?.dataPassing.data = data
            })
        }
        
        let configuration = Configuration<Result<UIViewController, Any>>(destination: .viewControllerBlock(viewControllerBlock))
        _configuration = configuration
        
        navigate(with: configuration)
        
        return configuration
    }
    
    // MARK: private
    
    private func navigate<T>(with configuration: Configuration<T>, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            Navigator.navigate(with: self.navigationType, configuration: configuration, completion: completion)
        }
    }
}

