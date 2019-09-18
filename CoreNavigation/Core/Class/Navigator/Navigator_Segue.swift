extension Navigator {
    func performSegue<DestinationType: Destination, FromType: UIViewController>(
        with segueIdentifier: String,
        configuration: Configuration<DestinationType, FromType>
        ) {
        let sourceViewController = configuration.sourceViewController
        sourceViewController.coreNavigationEvents = UIViewController.Observer()

        sourceViewController.coreNavigationEvents?.onPrepareForSegue({ [weak self] (segue, sender) in
            configuration.prepareForSegueBlock?(segue, sender)
            self?.passData(configuration.dataPassingBlock, to: [segue.destination], configuration: configuration)
            configuration.viewControllerEventBlocks.forEach({ (block) in
                self?.bindEvents(to: segue.destination as! DestinationType.ViewControllerType, navigationEvents: block())
            })
            if configuration.dataPassingBlock == nil {
                self?.prepareForStateRestorationIfNeeded(viewController: segue.destination, with: configuration, viewControllerData: nil)
            }
        })
                
        sourceViewController.performSegue(withIdentifier: segueIdentifier, sender: sourceViewController)
        
        sourceViewController.coreNavigationEvents = nil
    }
}
