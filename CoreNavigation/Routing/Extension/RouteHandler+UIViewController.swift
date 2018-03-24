import Foundation

extension RouteHandler where RouteType.Destination: DataReceivable {
    /// Notifies handler to proceed with navigation.
    ///
    /// - Parameter data: Data to pass to view controller.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(data: RouteType.Destination.DataType? = nil) -> RouteType.Destination {
        typealias DataBlock = (RouteType.Destination.DataType) -> Void
        
        let viewController = RouteType.Destination.init()
        
        destinationBlocks.forEach { $0(viewController) }
        if let data = data {
            viewController.didReceiveData(data)
            
            (dataBlocks as? [DataBlock])?.forEach { $0(data)}
        }
        
        destinationBlocks = []
        dataBlocks = []
        
        return viewController
    }
}
