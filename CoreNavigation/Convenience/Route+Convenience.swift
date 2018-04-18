import Foundation

// MARK: - Route view controller convenience
public extension Route {
    /// Route to view controller synchronously.
    ///
    /// - Returns: Route's view controller instance.
    /// - Throws: Throws error if view controller couldn't be resolved.
    public func viewController() throws -> ViewController {
        var viewController: ViewController?
        var error: Error?
        
        self.viewController({ (_viewController) in
            viewController = _viewController
        }) { (_error) in
            error = _error
        }
        
        guard let _viewController = viewController else {
            if let error = error {
                throw error
            } else {
                throw NavigationError.unknown
            }
        }
        
        return _viewController
    }
    
    /// Route to view controller asynchronously.
    ///
    /// - Parameters:
    ///   - viewControllerBlock: Block returning UIViewController instance.
    ///   - failure: Block returning Error instance.
    public func viewController(_ viewControllerBlock: @escaping (ViewController) -> Void, failure: ((Error) -> Void)? = nil) {
        let handler = RouteHandler<Self>(parameters: parameters)

        let configuration = Configuration<Result<ViewController, Any>>(destination: .viewControllerBlock({ block in
            handler.destinationBlocks.append({ (viewController, data) in
                block(.success(viewController))
            })
            handler.cancelBlocks.append({ (error) in
                block(.failure(error))
            })
            
        }), from: nil)
        
        Navigator.getViewController(configuration: configuration, completion: viewControllerBlock, failure: failure)
        
        type(of: self).route(handler: handler)
    }
    
    /// Presents view controller.
    ///
    /// - Parameter completion: Completion block.
    public func present(completion: (() -> Void)? = nil) {
        let configuration = To<Result<ViewController, Any>>(.present, from: nil).to(self)
        
        if let completion = completion {
            configuration.completion(completion)
        }
    }
    
    /// Presents view controller.
    ///
    /// - Parameter block: Configuration object.
    public func present(_ block: @escaping (Configuration<Result<ViewController, Any>>) -> Void) {
        block(To<Result<ViewController, Any>>(.present, from: nil).to(self))
    }
    
    /// Pushes view controller.
    ///
    /// - Parameter block: Configuration object.
    public func push(_ block: @escaping (Configuration<Result<ViewController, Any>>) -> Void) {
        block(To<Result<ViewController, Any>>(.push, from: nil).to(self))
    }
}
