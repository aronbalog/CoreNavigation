extension UIViewController {
    final public class Destination<ViewControllerType: UIViewController>: CoreNavigation.Destination {
        let viewController: ViewControllerType
        
        init(viewController: ViewControllerType) {
            self.viewController = viewController
        }
        
        public func resolve(_ resolver: Resolver<UIViewController.Destination<ViewControllerType>>) {
            resolver.complete(viewController: viewController)
        }
    }
}
