import Foundation

public class RouteHandler<RouteType: Route> {
    public let parameters: [String: Any]?
    
    var destinationBlocks: [(RouteType.Destination) -> Void] = []
    var dataBlocks: [Any] = []
    
    init(parameters: [String: Any]?) {
        self.parameters = parameters
    }
        
    public func destination(_ destination: RouteType.Destination) {
        destinationBlocks.forEach { $0(destination) }
        
        destinationBlocks = []
        dataBlocks = []
    }
    
    /// Notifies handler to proceed with navigation.
    ///
    /// - Returns: UIViewController instance.
    @discardableResult public func complete() -> RouteType.Destination {
        let viewController = RouteType.Destination.init(nibName: nil, bundle: nil)
        
        destinationBlocks.forEach { $0(viewController) }
        
        destinationBlocks = []
        dataBlocks = []
        
        return viewController
    }
}
