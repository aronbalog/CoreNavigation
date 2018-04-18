import Foundation

/// Handles route.
public class RouteHandler<RouteType: Route> {
    /// Parameters extracted from route's uri.
    public let parameters: [String: Any]?
    
    var destinationBlocks: [(RouteType.ViewController, Any?) -> Void] = []
    var cancelBlocks: [(Error) -> Void] = []
    
    init(parameters: [String: Any]?) {
        self.parameters = parameters
    }
    
    /// Notifies handler to proceed with navigation.
    ///
    /// - Parameter viewController: UIViewController instance to navigate to.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(viewController: RouteType.ViewController = .init()) -> RouteType.ViewController {
        destination(viewController, data: nil)
        
        return viewController
    }
    
    /// Notifies handler to cancel navigation.
    ///
    /// - Parameter error: Error instance.
    public func cancel(error: Error = NavigationError.unknown) {
        cancelBlocks.forEach { $0(error) }

        destinationBlocks = []
        cancelBlocks = []
    }
    
    func destination(_ destination: RouteType.ViewController, data: Any?) {
        destinationBlocks.forEach { $0(destination, data) }
        
        destinationBlocks = []
        cancelBlocks = []
    }
}

extension RouteHandler where RouteType.ViewController: DataReceivingViewController {
    /// Notifies handler to proceed with navigation.
    ///
    /// - Parameters:
    ///   - viewController: UIViewController instance to navigate to.
    ///   - data: Data to pass to view controller.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(viewController: RouteType.ViewController = .init(), data: RouteType.ViewController.DataType? = nil) -> RouteType.ViewController {
        
        destination(viewController, data: data)
        
        if let data = data {
            viewController.didReceiveData(data)
        }
        
        return viewController
    }
    
    /// Notifies handler to proceed with navigation.
    ///
    /// - Parameter data: Data to pass to view controller.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(data: RouteType.ViewController.DataType?) -> RouteType.ViewController {
        return self.complete(viewController: RouteType.ViewController.init(), data: data)
    }
}
