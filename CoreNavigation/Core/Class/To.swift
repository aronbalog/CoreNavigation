import Foundation
import UIKit

public class To<ResultableType: Resultable>: DestinationAware {
    public let navigationType: NavigationType
    
    public var destination: Destination?
    
    init(_ navigationType: NavigationType) {
        self.navigationType = navigationType
    }
    
    @discardableResult public func to<T>(_ destination: T) -> Configuration<Result<T>> where T : UIViewController {
        let viewController = destination
        let configuration = Configuration<Result<T>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    @discardableResult public func to<T>(_ destination: T.Type) -> Configuration<Result<T>> where T : UIViewController {
        let viewController = destination.init(nibName: nil, bundle: nil)
        let configuration = Configuration<Result<T>>(destination: .viewController(viewController))
        
        navigate(with: configuration)
        
        return configuration
    }
    
    private func navigate<T>(with configuration: Configuration<T>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            Navigator.navigate(with: self.navigationType, configuration: configuration)
        }
    }
}
