import Foundation

extension History {
    class Item<T: Resultable>: HistoryItem {
        weak var viewController: UIViewController?
        weak var configuration: Configuration<T>?
        
        let navigationType: NavigationType
        
        
        
        init(viewController: UIViewController, navigationType: NavigationType, configuration: Configuration<T>) {
            self.viewController = viewController
            self.navigationType = navigationType
            self.configuration = configuration
        }
        
        func go(_ direction: HistoryDirection, animated: Bool, completion: (() -> Void)?) {
            switch direction {
            case .back(_):
                guard let viewController = viewController else { return }
                
                switch self.navigationType {
                case .push:
                    pop(to: viewController, animated: animated, completion: completion)
                case .present:
                    dismiss(to: viewController, animated: animated, completion: completion)
                }
            default:
                ()
            }
        }
        
        private func pop(to viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
            var stack: [UIViewController] = []
            
            func makeStack(from viewController: UIViewController) {
                if let presentedViewController = viewController.presentedViewController {
                    stack.append(presentedViewController)
                    makeStack(from: presentedViewController)
                }
            }
            
            func dismissStack(animated: Bool, completion: (() -> Void)?) {
                guard !stack.isEmpty else {
                    completion?()
                    return
                }
                
                let viewControllerToDismiss = stack.removeLast()
                
                let overridenAnimated = stack.count > 1 ? false : animated
                
                viewControllerToDismiss.dismiss(animated: overridenAnimated) {
                    dismissStack(animated: animated, completion: completion)
                }
            }
            
            makeStack(from: viewController)
            dismissStack(animated: animated, completion: {
                if viewController.navigationController?.visibleViewController === viewController {
                    completion?()
                } else {
                    viewController.navigationController?.popToViewController(viewController, animated: animated, completion: completion)
                }
            })
        }
        
        private func dismiss(to viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
            var stack: [UIViewController] = []
            
            func makeStack(from viewController: UIViewController) {
                if let presentedViewController = viewController.presentedViewController {
                    stack.append(presentedViewController)
                    makeStack(from: presentedViewController)
                }
            }
            
            func dismissStack(animated: Bool, completion: (() -> Void)?) {
                guard !stack.isEmpty else {
                    completion?()
                    return
                }
                
                let overridenAnimated = stack.count > 1 ? false : animated

                let viewControllerToDismiss = stack.removeLast()
                
                viewControllerToDismiss.dismiss(animated: overridenAnimated) {
                    dismissStack(animated: animated, completion: completion)
                }
            }
            
            makeStack(from: viewController)
            dismissStack(animated: animated, completion: {
                if let navigationController = viewController as? UINavigationController {
                    navigationController.popToRootViewController(animated: animated, completion: completion)
                } else {
                    completion?()
                }
            })
        }
    }
}
