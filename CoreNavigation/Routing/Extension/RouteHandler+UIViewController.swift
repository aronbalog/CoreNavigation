import Foundation

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
            viewController.didReceiveData(data)
            
            dataBlocks.forEach { block in
                guard let block = block as? (RouteType.Destination.DataType) -> Void else { return }
                
                block(data)
            }
        }
        
        destinationBlocks = []
        dataBlocks = []
        
        return viewController
    }
}
