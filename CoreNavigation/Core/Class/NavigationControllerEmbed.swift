class NavigationControllerEmbed: Embeddable {
    func embed(rootViewController: UIViewController, handler: EmbeddingHandler) throws {
        handler.complete(viewController: UINavigationController(rootViewController: rootViewController))
    }
}
