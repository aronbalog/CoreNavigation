import Foundation

// MARK: - Route + UIViewController
public extension Route {
    /// Route to view controller.
    ///
    /// - Parameter viewControllerBlock: Block returning UIViewController instance.
    public func viewController(_ viewControllerBlock: @escaping (Self.Destination) -> Void) {
        let handler = RouteHandler<Self>(parameters: parameters)

        let configuration = Configuration<Result<Self.Destination, Any>>(destination: .viewControllerBlock({ handler.destinationBlocks.append($0) }), from: nil)
        
        Navigator.getViewController(configuration: configuration, completion: viewControllerBlock)
        
        type(of: self).route(handler: handler)
    }
}
