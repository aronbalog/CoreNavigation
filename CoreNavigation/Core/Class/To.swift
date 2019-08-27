public class To {
    private let navigationType: NavigationType
    private let queue: DispatchQueue
    
    init(navigationType: NavigationType, queue: DispatchQueue) {
        self.navigationType = navigationType
        self.queue = queue
    }
    
    @discardableResult public func to<DestinationType: Destination, FromType: UIViewController>(_ destination: DestinationType, from sourceViewController: FromType = UIViewController.visibleViewController()) -> Builder<DestinationType, FromType> {
        return Builder(configuration: Configuration<DestinationType, FromType>(navigationType: navigationType, to: destination, from: sourceViewController), queue: queue)
    }
    
    @discardableResult public func to<ViewControllerType: UIViewController, FromType: UIViewController>(_ viewController: ViewControllerType, from sourceViewController: FromType = UIViewController.visibleViewController()) -> Builder<UIViewController.Destination<ViewControllerType>, FromType> {
        return to(UIViewController.Destination(viewController: viewController), from: sourceViewController)
    }
}
