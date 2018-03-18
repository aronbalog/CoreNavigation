import Foundation

public class RouteHandler<RouteType: Route> {
    public let parameters: [String: Any]?
    
    var destinationBlocks: [(RouteType.Destination) -> Void] = []
    var dataBlocks: [Any] = []
    
    init(parameters: [String: Any]?) {
        self.parameters = parameters
    }
    
    func onDestination(_ completion: @escaping (RouteType.Destination) -> Void) {
        self.destinationBlocks.append(completion)
    }
    
    public func destination(_ destination: RouteType.Destination) {
        destinationBlocks.forEach { $0(destination) }
        
        destinationBlocks = []
        dataBlocks = []
    }
}
