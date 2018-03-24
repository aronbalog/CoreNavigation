import Foundation

extension RouteHandler where RouteType.Destination: DataReceivable {
    /// Notifies handler to proceed with navigation.
    ///
    /// - Parameter data: Data to pass to view controller.
    /// - Returns: UIViewController instance.
    @discardableResult public func complete(viewController: RouteType.Destination = .init(), data: RouteType.Destination.DataType? = nil) -> RouteType.Destination {        

        destination(viewController, data: data)
        
        if let data = data {
            viewController.didReceiveData(data)
        }
        
        return viewController
    }
    
    @discardableResult public func complete(data: RouteType.Destination.DataType?) -> RouteType.Destination {
        return self.complete(viewController: RouteType.Destination.init(), data: data)
    }
}
