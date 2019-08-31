let queue = DispatchQueue(label: "corenavigation.queue", attributes: .concurrent)

public func Navigate<DestinationType: Destination, FromType: UIViewController>(_ navigationDirection: NavigationDirection.Forward, _ to: (To) -> To.Builder<DestinationType, FromType>) {
    Navigator(queue: queue, cache: Caching.Cache.instance).navigate(with: to(To(navigationDirection: navigationDirection, queue: queue)).configuration)
}

public func Present<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> To.Builder<DestinationType, FromType>) {
    Navigate(.present, to)
}

public func Push<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> To.Builder<DestinationType, FromType>) {
    Navigate(.push, to)
}

public func AddChildViewController<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> To.Builder<DestinationType, FromType>) {
    Navigate(.childViewController, to)
}

public func Close<ViewControllerType: UIViewController>(_ navigationDirection: NavigationDirection.Backward, _ back: (Back) -> Back.Builder<ViewControllerType>) {
    Navigator(queue: queue, cache: Caching.Cache.instance).navigate(with: back(Back(navigationDirection: navigationDirection, queue: queue)).configuration)
}

public func Close(_ navigationDirection: NavigationDirection.Backward, animated: Bool = true, completion: (() -> Void)? = nil) {
    Close(navigationDirection) { $0
        .visibleViewController()
        .animated(animated)
        .onComplete { _ in completion?() }
    }
}

public func Close<ViewControllerType: UIViewController>(_ navigationDirection: NavigationDirection.Backward, viewController: ViewControllerType, animated: Bool = true, completion: (() -> Void)? = nil) {
    Close(navigationDirection) { $0
        .viewController(viewController)
        .animated(animated)
        .onComplete { _ in completion?() }
    }
}

public func Dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
    Close(.dismiss, animated: animated, completion: completion)
}

public func Dismiss<ViewControllerType: UIViewController>(viewController: ViewControllerType, animated: Bool = true, completion: (() -> Void)? = nil) {
    Close(.dismiss, viewController: viewController, animated: animated, completion: completion)
}

public func Pop(animated: Bool = true, completion: (() -> Void)? = nil) {
    Close(.pop, animated: animated, completion: completion)
}

public func Pop<ViewControllerType: UIViewController>(viewController: ViewControllerType, animated: Bool = true, completion: (() -> Void)? = nil) {
    Close(.pop, viewController: viewController, animated: animated, completion: completion)
}
