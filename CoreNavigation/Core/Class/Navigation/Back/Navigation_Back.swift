extension Navigation {
    public class Back {
        private let navigationType: Navigation.Direction
        private let queue: DispatchQueue

        init(navigationType: Navigation.Direction.Back, queue: DispatchQueue) {
            self.navigationType = .back(navigationType)
            self.queue = queue
        }

        @discardableResult public func viewController<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ viewController: FromViewControllerType) -> Back.Builder<FromViewControllerType, ToViewControllerType> {
            Back.Builder(configuration: Configuration(directive: .direction(navigationType), toBlock: { UIViewController.Destination<UIViewController>.None() }, from: viewController), queue: queue)
        }

        @discardableResult public func visibleViewController<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>() -> Back.Builder<FromViewControllerType, ToViewControllerType> {
            viewController(UIViewController.visibleViewController())
        }

    }
}
