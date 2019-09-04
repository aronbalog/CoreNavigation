extension Embedding.Embedder {
    class None: Embeddable {
        func embed(with context: Embedding.Context) throws {
            context.complete(viewController: context.rootViewController)
        }
    }
}
