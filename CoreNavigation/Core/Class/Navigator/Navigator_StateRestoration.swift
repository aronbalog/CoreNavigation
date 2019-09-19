extension Navigator {
    func prepareForStateRestorationIfNeeded(
        viewController: UIViewController,
        viewControllerData: Any?
    ) {
        guard let stateRestoration = configuration.stateRestorationBlock?() else { return }
        
        StateRestoration.prepare(
            viewController: viewController,
            identifier: stateRestoration.identifier,
            viewControllerData: viewControllerData,
            expirationDate: stateRestoration.expirationDate)
    }
}
