extension Embedding.Helper {
    class NavigationController: Embeddable {
        let navigationControllerType: UINavigationController.Type
        
        init(navigationControllerType: UINavigationController.Type) {
            self.navigationControllerType = navigationControllerType
        }
        
        func embed(with context: Embedding.Context) throws {
            let navigationController = navigationControllerType.init(rootViewController: context.rootViewController)
            
            context.complete(viewController: navigationController)
        }
    }
}
