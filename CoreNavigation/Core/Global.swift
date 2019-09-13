let queue = DispatchQueue(label: "corenavigation.queue", attributes: .concurrent)

let initFramework: Void = {
    UIViewController.swizzleMethods
}()

public func Navigate<DestinationType: Destination, FromType: UIViewController>(_ direction: Navigation.Direction.Forward, _ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigator(queue: queue, cache: Caching.Cache.instance).navigate(with: to(Navigation.To(direction: direction, queue: queue)).configuration)
}

public func Present<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigate(.present, to)
}

public func Push<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigate(.push, to)
}

public func AddChildViewController<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigate(.childViewController, to)
}

public func Close<FromViewControllerType: UIViewController, ToiewControllerType: UIViewController>(_ direction: Navigation.Direction.Backward, _ back: (Navigation.Back) -> Navigation.Back.Builder<FromViewControllerType, ToiewControllerType>) {
    Navigator(queue: queue, cache: Caching.Cache.instance).navigate(with: back(Navigation.Back(direction: direction, queue: queue)).configuration)
}

public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ direction: Navigation.Direction.Backward, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(direction) { $0
        .visibleViewController()
        .animated(animated)
        .onComplete({ (fromViewController, toViewController) in
            completion?(fromViewController as! FromViewControllerType, toViewController as! ToViewControllerType)
        })
    }
}

public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ direction: Navigation.Direction.Backward, viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(direction) { $0
        .viewController(viewController)
        .animated(animated)
        .onComplete({ (fromViewController, toViewController) in
            completion?(fromViewController, toViewController as! ToViewControllerType)
        })
    }
}

public func Dismiss<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.dismiss, animated: animated, completion: completion)
}

public func Dismiss<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.dismiss, viewController: viewController, animated: animated, completion: completion)
}

public func Pop<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.pop, animated: animated, completion: completion)
}

public func Pop<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.pop, viewController: viewController, animated: animated, completion: completion)
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
