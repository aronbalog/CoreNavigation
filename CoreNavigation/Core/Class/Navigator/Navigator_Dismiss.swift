extension Navigator {
    func dismiss(operation: Navigation.Operation) {        
        DispatchQueue.main.async {
            func action() {
                let sourceViewController = self.configuration.sourceViewController as! DestinationType.ViewControllerType
                
                sourceViewController.dismiss(animated: self.configuration.isAnimatedBlock(), completion: {
                    let result = self.doOnNavigationSuccess(
                        destination: self.configuration.destination,
                        viewController: UIViewController.visibleViewController()
                    )
                    
                    self.resultCompletion(
                        with: result,
                        operation: operation
                    )
                })
            }
            
            if
                let presentingViewController = UIViewController.visibleViewController().presentingViewController,
                let dataPassingElement = self.configuration.backDataPassingElements.first(where: { presentingViewController.isKind(of: $0.0) }) {
                self.passData(dataPassingElement.1, to: [
                    presentingViewController,
                    (presentingViewController as? UINavigationController)?.topViewController
                ])
            }
            
            if let delayBlock = self.configuration.delayBlock {
                let timeInterval = delayBlock()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: action)
            } else {
                DispatchQueue.main.async(execute: action)
            }
        }
    }
}
