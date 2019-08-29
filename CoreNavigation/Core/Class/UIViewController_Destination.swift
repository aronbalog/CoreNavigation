extension UIViewController {
    final public class Destination<ViewControllerType: UIViewController>: CoreNavigation.Destination {
        public static func resolve(parameters: [String : Any]?, destination: @escaping (UIViewController) -> Void, failure: @escaping (Error?) -> Void) throws {
            fatalError()
        }
        
        let block: () -> ViewControllerType
        
        init(block: @escaping () -> ViewControllerType) {
            self.block = block
        }
        
        public func resolve(with resolver: Resolver<UIViewController.Destination<ViewControllerType>>) {
            resolver.complete(viewController: block())
        }
    }
}

extension UIViewController.Destination {
    final public class None: CoreNavigation.Destination {
        public static func resolve(parameters: [String : Any]?, destination: @escaping (UIViewController) -> Void, failure: @escaping (Error?) -> Void) throws {
            failure(nil)
        }
    }
}
