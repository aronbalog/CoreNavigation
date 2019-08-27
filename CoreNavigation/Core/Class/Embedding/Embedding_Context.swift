extension Embedding {
    public class Context {
        public let rootViewController: UIViewController
        let onComplete: (UIViewController) -> Void
        let onCancel: (Error) -> Void
        
        init(rootViewController: UIViewController, onComplete: @escaping (UIViewController) -> Void, onCancel: @escaping (Error) -> Void) {
            self.rootViewController = rootViewController
            self.onComplete = onComplete
            self.onCancel = onCancel
        }
        
        public func complete(viewController: UIViewController) {
            onComplete(viewController)
        }
        
        public func cancel(with error: Error) {
            onCancel(error)
        }
    }
}
