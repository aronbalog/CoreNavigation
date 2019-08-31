public class Back {
    private let navigationDirection: NavigationDirection
    private let queue: DispatchQueue
    
    init(navigationDirection: NavigationDirection.Backward, queue: DispatchQueue) {
        self.navigationDirection = .backward(navigationDirection)
        self.queue = queue
    }
    
    @discardableResult public func viewController<FromType: UIViewController>(_ viewController: FromType) -> Back.Builder<FromType> {
        return Back.Builder(configuration: Configuration(navigationDirection: navigationDirection, toBlock: { UIViewController.Destination<UIViewController>.None() }, from: viewController), queue: queue)
    }
    
    @discardableResult public func visibleViewController<FromType: UIViewController>() -> Back.Builder<FromType> {
        return viewController(UIViewController.visibleViewController())
    }
    
}
