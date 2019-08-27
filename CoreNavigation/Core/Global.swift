    let queue = DispatchQueue(label: "corenavigation.queue", attributes: .concurrent)

public func Present<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> Builder<DestinationType, FromType>) {
    Navigate(.present, to)
}

public func Push<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> Builder<DestinationType, FromType>) {
    Navigate(.push, to)
}

public func Navigate<DestinationType: Destination, FromType: UIViewController>(_ navigationType: NavigationType, _ to: (To) -> Builder<DestinationType, FromType>) {
    Navigator(queue: queue).navigate(with: to(To(navigationType: navigationType, queue: queue)).configuration)
}
