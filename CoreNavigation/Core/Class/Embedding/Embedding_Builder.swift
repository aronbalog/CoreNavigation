extension Embedding {
    class Builder: Embeddable {
        let block: (Embedding.Context) -> Void

        init(block: @escaping (Embedding.Context) -> Void) {
            self.block = block
        }

        func embed(with context: Embedding.Context) throws {
            block(context)
        }
    }
}
