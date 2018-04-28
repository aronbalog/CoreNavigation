import Foundation

// MARK: - Matchable view controller convenience
public extension Matchable {
    /// Resolves view controller synchronously.
    ///
    /// - Returns: Destination's view controller instance.
    /// - Throws: Throws error if view controller couldn't be resolved.
    public func viewController() throws -> UIViewController {
        var viewController: UIViewController?
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

    /// Resolves view controller.
    ///
    /// - Parameters:
    ///   - viewControllerBlock: Block returning UIViewController instance.
    ///   - failure: Block returning Error instance.
    public func viewController<T: UIViewController>(_ viewControllerBlock: @escaping (T) -> Void, failure: ((Error) -> Void)? = nil) {
        UIViewController.resolve(self, viewControllerBlock, failure: failure)
    }

    /// Presents view controller after routing to self.
    ///
    /// - Parameter completion: Completion block.
    public func present(completion: (() -> Void)? = nil) {
        let configuration = To<Result<UIViewController, Any>>(.present, from: nil).to(self)

        if let completion = completion {
            configuration.completion(completion)
        }
    }

    /// Presents view controller after routing to self.
    ///
    /// - Parameter block: Navigation configuration block.
    public func present(_ block: @escaping (Configuration<Result<UIViewController, Any>>) -> Void) {
        block(To<Result<UIViewController, Any>>(.present, from: nil).to(self))
    }

    /// Pushes view controller after routing to self.
    ///
    /// - Parameter block: Navigation configuration block.
    public func push(_ block: @escaping (Configuration<Result<UIViewController, Any>>) -> Void) {
        block(To<Result<UIViewController, Any>>(.push, from: nil).to(self))
    }
}
