extension Navigator {
    func dismiss(operation: Navigation.Operation) {
        func action() {
            let sourceViewController = self.configuration.sourceViewController as! DestinationType.ViewControllerType
            
            sourceViewController.dismiss(animated: self.configuration.isAnimatedBlock(), completion: {
                self.resultCompletion(
                    with: self.doOnNavigationSuccess(
                        destination: self.configuration.destination,
                        viewController: UIViewController.visibleViewController()
                    ),
                    operation: operation
                )
            })
        }
        
        if let delayBlock = configuration.delayBlock {
            let timeInterval = delayBlock()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: action)
        } else {
            DispatchQueue.main.async(execute: action)
        }
    }
}
