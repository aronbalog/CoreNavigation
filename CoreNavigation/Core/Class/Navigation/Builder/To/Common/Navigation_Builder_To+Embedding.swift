extension Navigation.Builder.To {
    @discardableResult public func embed(inside embeddingType: Embedding.EmbeddingType) -> Self {
        queue.sync { configuration.embeddable = embeddingType.embeddable() }

        return self
    }

    @discardableResult public func embed(_ block: @escaping (Embedding.Context) -> Void) -> Self {
        queue.sync { configuration.embeddable = Embedding.Builder(block: block) }

        return self
    }
}
