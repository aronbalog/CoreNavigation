extension Embedding {
    public indirect enum EmbeddingType {
        case navigationController(UINavigationController.Type, () -> EmbeddingType)
        case tabBarController(UITabBarController.Type, () -> EmbeddingType)
        case pageViewController(UIPageViewController.Type, () -> EmbeddingType)
        case embeddable(Embeddable, () -> EmbeddingType)
        case none

        func embeddable() -> Embeddable {
            switch self {
            case .navigationController(let controllerType, let embedding):
                let rootEmbeddable = Embedding.Embedder.NavigationController(navigationControllerType: controllerType)

                return Embedding.Embedder.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: embedding().embeddable())
            case .tabBarController(let controllerType, let embedding):
                let rootEmbeddable = Embedding.Embedder.TabBarController(tabBarControllerType: controllerType)

                return Embedding.Embedder.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: embedding().embeddable())
            case .pageViewController(let controllerType, let embedding):
                let rootEmbeddable = Embedding.Embedder.PageViewController(pageViewControllerType: controllerType)
                
                return Embedding.Embedder.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: embedding().embeddable())
            case .embeddable(let aProtocol, let embedding):
                let rootEmbeddable = aProtocol

                return Embedding.Embedder.Wrapper(rootEmbeddable: rootEmbeddable, wrappingEmbeddable: embedding().embeddable())
            case .none:
                return Embedding.Embedder.None()
            }
        }
    }

}
