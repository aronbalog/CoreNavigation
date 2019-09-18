extension Embedding {
    /// Embedding context. Use it to embed given view controller.
    public class Context {
        let onComplete: (UIViewController) -> Void
        let onCancel: (Error) -> Void
        
        /// View controller that is going to be embedded.
        public let rootViewController: UIViewController
        
        init(
            rootViewController: UIViewController,
            onComplete: @escaping (UIViewController) -> Void,
            onCancel: @escaping (Error) -> Void
        ) {
            self.rootViewController = rootViewController
            self.onComplete = onComplete
            self.onCancel = onCancel
        }
        
        /// Completes embedding with new view controller.
        /// Call this method with `UIViewController` object as an argument.
        ///
        /// - Parameter viewController: View controller that embeds `rootViewController` value.
        public func complete(viewController: UIViewController) {
            onComplete(viewController)
        }
        
        /// Cancels embedding with error.
        /// Call this method with `Error` object as an argument.
        ///
        /// - Parameter error: `Error` value.
        public func cancel(with error: Error) {
            onCancel(error)
        }
    }
}
