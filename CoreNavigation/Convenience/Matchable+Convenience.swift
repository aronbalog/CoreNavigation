import Foundation

// MARK: - Matchable view controller convenience
public extension Matchable {
    /// Route to view controller.
    ///
    /// - Parameter viewControllerBlock: Block returning UIViewController instance.
    public func viewController<T: UIViewController>(_ viewControllerBlock: @escaping (T) -> Void) {
        UIViewController.route(to: self, viewControllerBlock)
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
