extension UIViewController {
    final public class Destination<ViewControllerType: UIViewController>: CoreNavigation.Destination {
        let block: () -> ViewControllerType
        
        init(block: @escaping () -> ViewControllerType) {
            self.block = block
        }
        
        public func resolve(with resolver: Resolver<UIViewController.Destination<ViewControllerType>>) {
            resolver.complete(viewController: block())
        }
        
        public func resolveRouting(with resolver: Resolver<Routing.Destination>) {
            // never gonna happen
        }
        
        public static func resolveDestination(parameters: [String : Any]?, destination: @escaping (UIViewController.Destination<ViewControllerType>) -> Void, failure: @escaping (Error?) -> Void) throws {
            // never gonna happen
        }
    }
}

extension UIViewController.Destination {
    final public class None: CoreNavigation.Destination {
        public static func resolveDestination(parameters: [String : Any]?, destination: @escaping (UIViewController.Destination<ViewControllerType>.None) -> Void, failure: @escaping (Error?) -> Void) throws {
            // never gonna happen

        }
        
        public func resolveRouting(with resolver: Resolver<Routing.Destination>) {
            // never gonna happen

        }
    }
}
