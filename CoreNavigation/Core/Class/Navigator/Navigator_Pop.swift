extension Navigator {
    func pop(operation: Navigation.Operation) {
        func action() {
            let navigationController: UINavigationController? = {
                return self.configuration.sourceViewController.navigationController ?? self.configuration.sourceViewController as? UINavigationController
            }()
            navigationController?.popViewController(animated: self.configuration.isAnimatedBlock(), completion: {
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
    
    func popToRootViewController(operation: Navigation.Operation) {
        func action() {
            let navigationController: UINavigationController? = {
                return self.configuration.sourceViewController.navigationController ?? self.configuration.sourceViewController as? UINavigationController
            }()
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
