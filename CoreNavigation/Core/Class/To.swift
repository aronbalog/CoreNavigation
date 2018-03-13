import Foundation
import UIKit

public class To<ResultableType: Resultable>: DestinationAware {
    public let navigationType: NavigationType
    
    public var destination: Destination?
    
    init(_ navigationType: NavigationType) {
        self.navigationType = navigationType
    }
    
    @discardableResult public func to<T>(_ viewController: T) -> Configuration<Result<T, Any>> where T : UIViewController {
        let configuration = Configuration<Result<T, Any>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    @discardableResult public func to<T: DataReceivable>(_ viewController: T) -> Configuration<Result<T, T.DataType>> {
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    @discardableResult public func to<T>(_ viewControllerClass: T.Type) -> Configuration<Result<T, Any>> where T : UIViewController {
        let viewController = viewControllerClass.init(nibName: nil, bundle: nil)
        let configuration = Configuration<Result<T, Any>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    @discardableResult public func to<T: DataReceivable>(_ viewControllerClass: T.Type) -> Configuration<Result<T, T.DataType>> {
        let viewController = viewControllerClass.init(nibName: nil, bundle: nil)
        let configuration = Configuration<Result<T, T.DataType>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    @discardableResult public func to<T: Route>(_ route: T) -> Configuration<Result<T.Destination, Any>> {
        let handler = RouteHandler<T>()

        let configuration = Configuration<Result<T.Destination, Any>>(destination: .viewControllerBlock(handler.onDestination))
        
        self.navigate(with: configuration, completion: {
            route.route(handler: handler)
        })
        
        return configuration
    }
    
    @discardableResult public func to<T: Route>(_ route: T) -> Configuration<Result<T.Destination, T.Destination.DataType>> where T.Destination: DataReceivable {
        let handler = RouteHandler<T>()

        let configuration = Configuration<Result<T.Destination, T.Destination.DataType>>(destination: .viewControllerBlock(handler.onDestination))
        
        handler.onData({ (data) in
            configuration.dataPassing.data = data
        })
        
        self.navigate(with: configuration, completion: {
            route.route(handler: handler)
        })
        
        return configuration
    }
    
    private func navigate<T>(with configuration: Configuration<T>, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            Navigator.navigate(with: self.navigationType, configuration: configuration, completion: completion)
        }
    }
}

