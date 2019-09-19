extension Embedding.Embedder {
    class NavigationController: Embeddable {
        let navigationControllerType: UINavigationController.Type

        init(navigationControllerType: UINavigationController.Type) {
            self.navigationControllerType = navigationControllerType
        }

        func embed(with context: Embedding.Context) throws {
            DispatchQueue.main.async {
                let navigationController = self.navigationControllerType.init(rootViewController: context.rootViewController)
                
                context.complete(viewController: navigationController)
            }
        }
    }
}
