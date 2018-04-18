import Foundation

// MARK: - Destination convenience
public extension Destination {
    /// Resolves view controller synchronously.
    ///
    /// - Returns: Destination's view controller instance.
    /// - Throws: Throws error if view controller couldn't be resolved.
    public func viewController() throws -> ViewControllerType {
        var viewController: ViewControllerType?
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
    
    /// Resolves view controller asynchronously.
    ///
    /// - Parameters:
    ///   - viewControllerBlock: Block returning UIViewController instance.
    ///   - failure: Block returning Error instance.
    public func viewController(_ viewControllerBlock: @escaping (ViewControllerType) -> Void, failure: ((Error) -> Void)? = nil) {
        let context = Context<Self>(parameters: parameters)

        let configuration = Configuration<Result<ViewControllerType, Any>>(request: .viewControllerBlock({ block in
            context.destinationBlocks.append({ (viewController, data) in
                block(.success(viewController))
            })
            context.cancelBlocks.append({ (error) in
                block(.failure(error))
            })
            
        }), from: nil)
        
        Navigator.getViewController(configuration: configuration, completion: viewControllerBlock, failure: failure)
        
        type(of: self).resolve(context: context)
    }
    
    /// Presents view controller.
    ///
    /// - Parameter completion: Completion block.
    public func present(completion: (() -> Void)? = nil) {
        let configuration = To<Result<ViewControllerType, Any>>(.present, from: nil).to(self)
        
        if let completion = completion {
            configuration.completion(completion)
        }
    }
    
    /// Presents view controller.
    ///
    /// - Parameter block: Configuration object.
    public func present(_ block: @escaping (Configuration<Result<ViewControllerType, Any>>) -> Void) {
        block(To<Result<ViewControllerType, Any>>(.present, from: nil).to(self))
    }
    
    /// Pushes view controller.
    ///
    /// - Parameter block: Configuration object.
    public func push(_ block: @escaping (Configuration<Result<ViewControllerType, Any>>) -> Void) {
        block(To<Result<ViewControllerType, Any>>(.push, from: nil).to(self))
    }
}
