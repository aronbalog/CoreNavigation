public protocol Embeddable {
    func embed(with context: Embedding.Context) throws
}
