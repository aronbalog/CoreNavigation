extension Embedding.Embedder {
    class TabBarController: Embeddable {
        let tabBarControllerType: UITabBarController.Type

        init(tabBarControllerType: UITabBarController.Type) {
            self.tabBarControllerType = tabBarControllerType
        }

        func embed(with context: Embedding.Context) throws {
            DispatchQueue.main.async {
                let tabBarController = self.tabBarControllerType.init()
                
                tabBarController.viewControllers = [context.rootViewController]
                
                context.complete(viewController: tabBarController)
            }
        }
    }
}
