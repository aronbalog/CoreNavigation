import UIKit

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
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, _ completion: @escaping (() -> Void)) {
        pushViewController(viewController, animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, _ completion: @escaping (() -> Void)) {
        popViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, _ completion: @escaping (() -> Void)) {
        popToRootViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
}

