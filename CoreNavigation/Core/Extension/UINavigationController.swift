extension UINavigationController {
    private func doAfterAnimatingTransition(animated: Bool, completion: (() -> Void)?) {
        guard let completion = completion else {
            return
        }
        
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                completion()
            })
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        pushViewController(viewController, animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completion: (() -> Void)?) {
        popViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        popToViewController(viewController, animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        popToRootViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
}
