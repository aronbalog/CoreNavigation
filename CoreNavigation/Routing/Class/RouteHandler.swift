import Foundation

public class RouteHandler<RouteType: Route> {
    public let parameters: [String: Any]?
    
    var destinationBlocks: [(RouteType.Destination, Any?) -> Void] = []
    
    init(parameters: [String: Any]?) {
        self.parameters = parameters
    }
    
    /// Notifies handler to proceed with navigation.
    ///
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(viewController: RouteType.Destination = .init()) -> RouteType.Destination {        
        destination(viewController, data: nil)
        
        return viewController
    }
    
    func destination(_ destination: RouteType.Destination, data: Any?) {
        destinationBlocks.forEach { $0(destination, data) }
        
        destinationBlocks = []
    }
}
