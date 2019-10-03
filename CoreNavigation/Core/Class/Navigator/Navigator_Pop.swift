extension Navigator {
    func pop(operation: Navigation.Operation) {
        DispatchQueue.main.async {
            guard
                let navigationController = {
                    self.configuration.sourceViewController.navigationController ?? self.configuration.sourceViewController as? UINavigationController
                }()
            else {
                self.resultFailure(with: Navigation.Error.unknownNavigationController, operation: operation)
                return
            }
            
            var viewControllers = navigationController.viewControllers
            if !viewControllers.isEmpty {
                viewControllers.removeLast()
            }
            
            guard let destinationViewController = viewControllers.last else {
                self.resultFailure(with: Navigation.Error.unknownNavigationController, operation: operation)
                return
            }
            
            func action() {
                navigationController.popViewController(animated: self.configuration.isAnimatedBlock(), completion: {
                    let result = self.doOnNavigationSuccess(destination: self.configuration.destination, viewController: destinationViewController as! DestinationType.ViewControllerType)
                    self.resultCompletion(with: result, operation: operation)       
                })
            }
            
            if let dataPassingElement = self.configuration.backDataPassingElements.first(where: { destinationViewController.isKind(of: $0.0) }) {
                self.passData(dataPassingElement.1, to: [destinationViewController])
            }
            
            if let delayBlock = self.configuration.delayBlock {
                let timeInterval = delayBlock()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: action)
            } else {
                DispatchQueue.main.async(execute: action)
            }
        }
    }
    
    func popToRootViewController(operation: Navigation.Operation) {
        func action() {
            let navigationController: UINavigationController? = {
                self.configuration.sourceViewController.navigationController ?? self.configuration.sourceViewController as? UINavigationController
            }()
            
            if
                let destinationViewController = navigationController?.viewControllers.first,
                let dataPassingElement = self.configuration.backDataPassingElements.first(where: { destinationViewController.isKind(of: $0.0) }) {
                self.passData(dataPassingElement.1, to: [destinationViewController])
            }
            
            navigationController?.popToRootViewController(animated: self.configuration.isAnimatedBlock(), completion: {
                let result = self.doOnNavigationSuccess(destination: self.configuration.destination, viewController: UIViewController.visibleViewController())
                self.resultCompletion(with: result, operation: operation)
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
