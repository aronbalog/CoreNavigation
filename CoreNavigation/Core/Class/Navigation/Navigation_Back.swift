extension Navigation {
    public class Back<BuildableType: Buildable> {
        private let navigationType: Navigation.Direction
        private let queue: DispatchQueue

        init(navigationType: Navigation.Direction.Back, queue: DispatchQueue) {
            self.navigationType = .back(navigationType)
            self.queue = queue
        }

        @discardableResult public func viewController<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ viewController: FromViewControllerType) -> BuildableType where BuildableType.DestinationType == UIViewController.Destination<ToViewControllerType>.None, BuildableType.FromType == FromViewControllerType {
            BuildableType.init(configuration: Configuration(directive: .direction(navigationType), toBlock: { UIViewController.Destination<ToViewControllerType>.None() }, from: viewController), queue: queue)
        }

        @discardableResult public func visibleViewController<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>() -> BuildableType where BuildableType.DestinationType == UIViewController.Destination<ToViewControllerType>.None, BuildableType.FromType == FromViewControllerType {
            viewController(UIViewController.visibleViewController())
        }

    }
}
