extension Embedding.Helper {
    class TabBarController: Embeddable {
        func embed(with context: Embedding.Context) throws {
            let tabBarController = UITabBarController()
            
            tabBarController.viewControllers = [context.rootViewController]
            
            context.complete(viewController: tabBarController)
        }
    }
}
