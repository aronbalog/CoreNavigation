import Foundation

public class RouteHandler<RouteType: Route> {
    var destinationBlocks: [(RouteType.Destination) -> Void] = []
    var dataBlocks: [Any] = []

    func onDestination(_ completion: @escaping (RouteType.Destination) -> Void) {
        self.destinationBlocks.append(completion)
    }
    
    public func destination(_ destination: RouteType.Destination) {
        destinationBlocks.forEach { $0(destination) }
        
        destinationBlocks = []
        dataBlocks = []
    }
}

extension RouteHandler where RouteType.Destination: UIViewController {
    @discardableResult public func complete() -> RouteType.Destination {
        let viewController = RouteType.Destination.init(nibName: nil, bundle: nil)
        
        destinationBlocks.forEach { $0(viewController) }
        
        destinationBlocks = []
        dataBlocks = []
        
        return viewController
    }
}

extension RouteHandler where RouteType.Destination: DataReceivable {
    func onData(_ completion: @escaping (RouteType.Destination.DataType) -> Void) {
        self.dataBlocks.append(completion)
    }
    
    @discardableResult public func complete(data: RouteType.Destination.DataType? = nil) -> RouteType.Destination {
        let viewController = RouteType.Destination.init(nibName: nil, bundle: nil)
        
        destinationBlocks.forEach { $0(viewController) }
        if let data = data {
            dataBlocks.forEach { block in
                guard let block = block as? (RouteType.Destination.DataType) -> Void else { return }
                
                block(data)
            }
        }

        destinationBlocks = []
        
        return viewController
    }
}

public protocol Route {
    associatedtype Destination
    
    func route(handler: RouteHandler<Self>)
}

extension Route where Destination: UIViewController {
    public func route(handler: RouteHandler<Self>) {
        let viewController = Destination.init(nibName: nil, bundle: nil)
        
        handler.destination(viewController)
    }
}
