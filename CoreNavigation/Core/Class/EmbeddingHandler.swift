public class EmbeddingHandler {
    let onComplete: (UIViewController) -> Void
    let onCancel: (Error) -> Void
    
    init(onComplete: @escaping (UIViewController) -> Void, onCancel: @escaping (Error) -> Void) {
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
