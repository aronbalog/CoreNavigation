extension Embedding {
    public indirect enum EmbeddingType {
        case navigationController(EmbeddingType?)
        case tabBarController(EmbeddingType?)
        case embeddable(Embeddable, EmbeddingType?)
        
        func embeddable() -> Embeddable {
            switch self {
            case .navigationController(let newEmbedding):
                let rootEmbeddable = Embedding.Helper.NavigationController()
                if let newEmbedding = newEmbedding {
                    return Embedding.Helper.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: newEmbedding.embeddable())
                }
                return rootEmbeddable
            case .tabBarController(let newEmbedding):
                let rootEmbeddable = Embedding.Helper.TabBarController()
                if let newEmbedding = newEmbedding {
                    return Embedding.Helper.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: newEmbedding.embeddable())
                }
                return rootEmbeddable
            case .embeddable(let aProtocol, let newEmbedding):
                let rootEmbeddable = aProtocol
                if let newEmbedding = newEmbedding {
                    return Embedding.Helper.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: newEmbedding.embeddable())
                }
                return rootEmbeddable
            }
        }
    }

}
