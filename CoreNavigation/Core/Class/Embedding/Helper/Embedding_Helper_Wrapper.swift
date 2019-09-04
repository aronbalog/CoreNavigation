extension Embedding.Helper {
    class Wrapper: Embeddable {
        let rootEmbeddable: Embeddable
        let wrappingEmbeddable: Embeddable
        
        init(rootEmbeddable: Embeddable, wrappingEmbeddable: Embeddable) {
            self.rootEmbeddable = rootEmbeddable
            self.wrappingEmbeddable = wrappingEmbeddable
        }
        
        func embed(with context: Embedding.Context) throws {
            try wrappingEmbeddable.embed(with: Embedding.Context(rootViewController: context.rootViewController, onComplete: { (embeddingViewController) in
                let rootContext = Embedding.Context(rootViewController: embeddingViewController, onComplete: context.complete, onCancel: context.cancel)
                
                do {
                    try self.rootEmbeddable.embed(with: rootContext)
                } catch let error {
                    rootContext.cancel(with: error)
                }
            }) { (error) in
                context.cancel(with: error)
            })
        }
    }
}
