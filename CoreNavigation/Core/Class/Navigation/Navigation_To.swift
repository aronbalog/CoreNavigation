extension Navigation {
    public class To<BuildableType: Buildable> {
        private let navigationType: Navigation.Direction
        private let queue: DispatchQueue

        init(navigationType: Navigation.Direction.Forward, queue: DispatchQueue) {
            self.navigationType = .forward(navigationType)
            self.queue = queue
        }

        @discardableResult public func to(_ block: @escaping () -> BuildableType.DestinationType, from sourceViewController: BuildableType.FromType = UIViewController.visibleViewController()) -> BuildableType {
            BuildableType.init(configuration: Configuration(directive: .direction(navigationType), toBlock: block, from: sourceViewController), queue: queue)
        }

        @discardableResult public func to(_ destination: BuildableType.DestinationType, from sourceViewController: BuildableType.FromType = UIViewController.visibleViewController()) -> BuildableType {
            to({ destination }, from: sourceViewController)
        }

        @discardableResult public func to<FromType: UIViewController>(_ route: Matchable, from sourceViewController: BuildableType.FromType = UIViewController.visibleViewController()) -> BuildableType where BuildableType.DestinationType == Routing.Destination, BuildableType.FromType == FromType {
            to(Routing.Destination(route: route), from: sourceViewController)
        }

        @discardableResult public func to<ViewControllerType: UIViewController, FromType: UIViewController>(_ viewController: ViewControllerType, from sourceViewController: FromType = UIViewController.visibleViewController()) -> BuildableType where BuildableType.DestinationType == UIViewController.Destination<ViewControllerType>, BuildableType.FromType == FromType {
            to(UIViewController.Destination(block: { viewController }), from: sourceViewController)
        }

        @discardableResult public func to<ViewControllerType: UIViewController, FromType: UIViewController>(_ viewControllerType: ViewControllerType.Type, from sourceViewController: FromType = UIViewController.visibleViewController()) -> BuildableType where BuildableType.DestinationType == UIViewController.Destination<ViewControllerType>, BuildableType.FromType == FromType {
            to(UIViewController.Destination(block: { viewControllerType.init() }), from: sourceViewController)
        }

        @discardableResult public func to<ViewControllerType: UIViewController, FromType: UIViewController>(_ block: @escaping () -> ViewControllerType, from sourceViewController: FromType = UIViewController.visibleViewController()) -> BuildableType where BuildableType.DestinationType == UIViewController.Destination<ViewControllerType>, BuildableType.FromType == FromType {
            to(UIViewController.Destination(block: block), from: sourceViewController)
        }
    }

}
