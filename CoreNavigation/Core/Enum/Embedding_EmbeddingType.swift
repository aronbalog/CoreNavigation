extension Embedding {
    public indirect enum EmbeddingType {
        case navigationController(UINavigationController.Type, () -> EmbeddingType)
        case tabBarController(UITabBarController.Type, () -> EmbeddingType)
        case embeddable(Embeddable, () -> EmbeddingType)
        case none
        
        func embeddable() -> Embeddable {
            switch self {
            case .navigationController(let controllerType, let embedding):
                let rootEmbeddable = Embedding.Helper.NavigationController(navigationControllerType: controllerType)

                return Embedding.Helper.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: embedding().embeddable())
            case .tabBarController(let controllerType, let embedding):
                let rootEmbeddable = Embedding.Helper.TabBarController(tabBarControllerType: controllerType)

                return Embedding.Helper.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: embedding().embeddable())
            case .embeddable(let aProtocol, let embedding):
                let rootEmbeddable = aProtocol

                return Embedding.Helper.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: embedding().embeddable())
            case .none:
                return Embedding.Helper.None()
            }
        }
    }

}
