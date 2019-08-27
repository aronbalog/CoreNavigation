class BuilderEmbedding: Embeddable {
    let block: (EmbeddingHandler) -> Void
    
    init(block: @escaping (EmbeddingHandler) -> Void) {
        self.block = block
    }
    
    func embed(rootViewController: UIViewController, handler: EmbeddingHandler) throws {
        block(handler)
    }
}
