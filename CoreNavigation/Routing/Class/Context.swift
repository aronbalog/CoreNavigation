import Foundation

/// Destination context.
public class Context<DestinationType: Destination> {
    /// Parameters extracted from route's uri.
    public let parameters: [String: Any]?
    
    var destinationBlocks: [(DestinationType.ViewControllerType, Any?) -> Void] = []
    var cancelBlocks: [(Error) -> Void] = []
    
    init(parameters: [String: Any]?) {
        self.parameters = parameters
    }
    
    /// Proceeds with navigation.
    ///
    /// - Parameter viewController: UIViewController instance to navigate to.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(viewController: DestinationType.ViewControllerType = .init()) -> DestinationType.ViewControllerType {
        destination(viewController, data: nil)
        
        return viewController
    }
    
    /// Cancels navigation.
    ///
    /// - Parameter error: Error instance.
    public func cancel(error: Error = NavigationError.unknown) {
        cancelBlocks.forEach { $0(error) }

        destinationBlocks = []
        cancelBlocks = []
    }
    
    func destination(_ destination: DestinationType.ViewControllerType, data: Any?) {
        destinationBlocks.forEach { $0(destination, data) }
        
        destinationBlocks = []
        cancelBlocks = []
    }
}

extension Context where DestinationType.ViewControllerType: DataReceivable {
    /// Proceeds with navigation.
    ///
    /// - Parameters:
    ///   - viewController: UIViewController instance to navigate to.
    ///   - data: Data to pass to view controller.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(viewController: DestinationType.ViewControllerType = .init(), data: DestinationType.ViewControllerType.DataType? = nil) -> DestinationType.ViewControllerType {
        
        destination(viewController, data: data)
        
        if let data = data {
            viewController.didReceiveData(data)
        }
        
        return viewController
    }
    
    /// Cancels navigation.
    ///
    /// - Parameter data: Data to pass to view controller.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(data: DestinationType.ViewControllerType.DataType?) -> DestinationType.ViewControllerType {
        return self.complete(viewController: DestinationType.ViewControllerType.init(), data: data)
    }
}
