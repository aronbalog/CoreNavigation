extension UIViewController {
    final public class Destination<ViewControllerType: UIViewController>: CoreNavigation.Destination {
        let block: () -> ViewControllerType

        init(block: @escaping () -> ViewControllerType) {
            self.block = block
        }

        public func resolve(with resolver: Resolver<UIViewController.Destination<ViewControllerType>>) {
            DispatchQueue.main.async {
                resolver.complete(viewController: self.block())
            }
        }
    }
}

extension UIViewController.Destination {
    public final class None: CoreNavigation.Destination {}
}
