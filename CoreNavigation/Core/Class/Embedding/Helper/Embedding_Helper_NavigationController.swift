extension Embedding.Helper {
    class NavigationController: Embeddable {
        func embed(with context: Embedding.Context) throws {
            context.complete(viewController: UINavigationController(rootViewController: context.rootViewController))
        }
    }
}
