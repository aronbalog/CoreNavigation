extension Navigator {
    func performSegue<DestinationType: Destination, FromType: UIViewController>(
        with identifier: String,
        configuration: Configuration<DestinationType, FromType>) {
        let sourceViewController = configuration.sourceViewController
        
        sourceViewController.performSegue(withIdentifier: identifier, sender: sourceViewController)
    }
}
