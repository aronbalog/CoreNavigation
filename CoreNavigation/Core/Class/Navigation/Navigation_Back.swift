extension Navigation {
    public class Back {
        private let direction: Navigation.Direction
        private let queue: DispatchQueue
        
        init(direction: Navigation.Direction.Backward, queue: DispatchQueue) {
            self.direction = .backward(direction)
            self.queue = queue
        }
        
        @discardableResult public func viewController<FromType: UIViewController>(_ viewController: FromType) -> Back.Builder<FromType> {
            return Back.Builder(configuration: Configuration(directive: .direction(direction), toBlock: { UIViewController.Destination<UIViewController>.None() }, from: viewController), queue: queue)
        }
        
        @discardableResult public func visibleViewController<FromType: UIViewController>() -> Back.Builder<FromType> {
            return viewController(UIViewController.visibleViewController())
        }
        
    }
}
