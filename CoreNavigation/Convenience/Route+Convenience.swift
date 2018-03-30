import Foundation

// MARK: - Route view controller convenience
public extension Route {
    /// Route to view controller.
    ///
    /// - Parameter viewControllerBlock: Block returning UIViewController instance.
    public func viewController(_ viewControllerBlock: @escaping (Destination) -> Void) {
        let handler = RouteHandler<Self>(parameters: parameters)

        let configuration = Configuration<Result<Destination, Any>>(destination: .viewControllerBlock({ block in
            handler.destinationBlocks.append({ (viewController, data) in
                block(viewController)
            })
            
        }), from: nil)
        
        Navigator.getViewController(configuration: configuration, completion: viewControllerBlock)
        
        type(of: self).route(handler: handler)
    }
    
    /// Presents view controller.
    ///
    /// - Parameter completion: Completion block.
    public func present(completion: (() -> Void)? = nil) {
        let configuration = To<Result<Destination, Any>>(.present, from: nil).to(self)
        
        if let completion = completion {
            configuration.completion(completion)
        }
    }
    
    /// Presents view controller.
    ///
    /// - Parameter block: Configuration object.
    public func present(_ block: @escaping (Configuration<Result<Destination, Any>>) -> Void) {
        block(To<Result<Destination, Any>>(.present, from: nil).to(self))
    }
    
    /// Pushes view controller.
    ///
    /// - Parameter block: Configuration object.
    public func push(_ block: @escaping (Configuration<Result<Destination, Any>>) -> Void) {
        block(To<Result<Destination, Any>>(.push, from: nil).to(self))
    }
}
