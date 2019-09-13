extension Navigation {
    public class Back {
        private let direction: Navigation.Direction
        private let queue: DispatchQueue
        
        init(direction: Navigation.Direction.Backward, queue: DispatchQueue) {
            self.direction = .backward(direction)
            self.queue = queue
        }
        
        @discardableResult public func viewController<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ viewController: FromViewControllerType) -> Back.Builder<FromViewControllerType, ToViewControllerType> {
            return Back.Builder(configuration: Configuration(directive: .direction(direction), toBlock: { UIViewController.Destination<UIViewController>.None() }, from: viewController), queue: queue)
        }
        
        @discardableResult public func visibleViewController<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>() -> Back.Builder<FromViewControllerType, ToViewControllerType> {
            return viewController(UIViewController.visibleViewController())
        }
        
    }
}
