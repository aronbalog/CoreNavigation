import Foundation
import UIKit

public class To<ResultableType: Resultable>: DestinationAware {
    public let navigationType: NavigationType
    
    public var destination: Destination?
    
    init(_ navigationType: NavigationType) {
        self.navigationType = navigationType
    }
    
    @discardableResult public func to<T1>(_ destination: T1) -> Configuration<Result<T1, Any>> where T1 : UIViewController {
        let viewController = destination
        let configuration = Configuration<Result<T1, Any>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    @discardableResult public func to<T1: ParametersAware>(_ destination: T1) -> Configuration<Result<T1, T1.ParametersType>> {
        let viewController = destination
        let configuration = Configuration<Result<T1, T1.ParametersType>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    @discardableResult public func to<T1>(_ destination: T1.Type) -> Configuration<Result<T1, Any>> where T1 : UIViewController {
        let viewController = destination.init(nibName: nil, bundle: nil)
        let configuration = Configuration<Result<T1, Any>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    private func navigate<T>(with configuration: Configuration<T>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            Navigator.navigate(with: self.navigationType, configuration: configuration)
        }
    }
}
