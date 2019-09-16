let queue = DispatchQueue(label: "corenavigation.queue", attributes: .concurrent)

let initFramework: Void = {
    UIViewController.swizzleMethods
}()

public func Navigate<DestinationType: Destination, FromType: UIViewController>(_ direction: Navigation.Direction.Forward, _ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigator(queue: queue).navigate(with: to(Navigation.To(direction: direction, queue: queue)).configuration)
}

public func AddChildViewController<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigate(.childViewController, to)
}

public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ direction: Navigation.Direction.Back, _ back: (Navigation.Back) -> Navigation.Back.Builder<FromViewControllerType, ToViewControllerType>) {
    Navigator(queue: queue).navigate(with: back(Navigation.Back(direction: direction, queue: queue)).configuration)
}

public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ direction: Navigation.Direction.Back, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(direction) { $0
        .visibleViewController()
        .animated(animated)
        .onComplete({ (fromViewController, toViewController) in
            completion?(fromViewController as! FromViewControllerType, toViewController as! ToViewControllerType)
        })
    }
}

public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ direction: Navigation.Direction.Back, viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(direction) { $0
        .viewController(viewController)
        .animated(animated)
        .onComplete({ (fromViewController, toViewController) in
            completion?(fromViewController, toViewController as! ToViewControllerType)
        })
    }
}

public func Register<RoutableType: Routable>(_ routableType: RoutableType.Type) {
    Routing.Router.instance.register(routableType: routableType)
}

public func Register(_ destinationType: AnyDestination.Type, patterns: [String]) {
    Routing.Router.instance.register(destinationType: destinationType, patterns: patterns)
}

public func Unregister(_ destinationType: AnyDestination.Type) {
    Routing.Router.instance.unregister(destinationType: destinationType)
}

public func Unregister(matching pattern: String) {
    Routing.Router.instance.unregister(pattern: pattern)
}
