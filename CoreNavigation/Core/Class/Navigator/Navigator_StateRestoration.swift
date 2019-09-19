extension Navigator {
    func prepareForStateRestorationIfNeeded<DestinationType: Destination, FromType: UIViewController>(
        viewController: UIViewController,
        with configuration: Configuration<DestinationType, FromType>,
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
