public protocol Embeddable {
    func embed(rootViewController: UIViewController, handler: EmbeddingHandler) throws
}
