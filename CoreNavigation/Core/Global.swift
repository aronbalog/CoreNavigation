    let queue = DispatchQueue(label: "corenavigation.queue", attributes: .concurrent)

public func Present<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> Builder<DestinationType, FromType>) {
    Navigate(.present, to)
}

public func Push<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> Builder<DestinationType, FromType>) {
    Navigate(.push, to)
}

public func AddChildViewController<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> Builder<DestinationType, FromType>) {
    Navigate(.childViewController, to)
}
    
public func Dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
    Navigate(.dismiss) { $0
        .dismiss()
        .animated(animated)
        .onComplete({ (result) in
            completion?()
        })
    }
}
    
public func Dismiss<ViewControllerType: UIViewController>(viewController: ViewControllerType, animated: Bool = true, completion: (() -> Void)? = nil) {
    Navigate(.dismiss) { $0
        .dismiss(viewController: viewController)
        .animated(animated)
        .onComplete({ (result) in
            completion?()
        })
    }
}
    
public func Navigate<DestinationType: Destination, FromType: UIViewController>(_ navigationType: NavigationType, _ to: (To) -> Builder<DestinationType, FromType>) {
    Navigator(queue: queue, cache: Caching.Cache.instance).navigate(with: to(To(navigationType: navigationType, queue: queue)).configuration)
}
