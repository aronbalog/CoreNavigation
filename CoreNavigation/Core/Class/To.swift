public class To {
    let navigationType: NavigationType
    let queue: DispatchQueue
    
    init(navigationType: NavigationType, queue: DispatchQueue) {
        self.navigationType = navigationType
        self.queue = queue
    }
    
    @discardableResult public func to<DestinationType: Destination, FromType: UIViewController>(_ destination: DestinationType) -> Builder<DestinationType, FromType> {
        let configuration = Configuration<DestinationType, FromType>(navigationType: navigationType)
        
        queue.sync {
            configuration.to = destination
        }
        
        return Builder(configuration: configuration, queue: queue)
    }
    
    @discardableResult public func to<ViewControllerType: UIViewController, FromType: UIViewController>(_ viewController: ViewControllerType) -> Builder<UIViewController.Destination<ViewControllerType>, FromType> {
        let configuration = Configuration<UIViewController.Destination<ViewControllerType>, FromType>(navigationType: navigationType)

        queue.sync {
            configuration.to = UIViewController.Destination(viewController: viewController)
        }
        
        return Builder(configuration: configuration, queue: queue)
    }
}
