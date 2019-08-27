let queue = DispatchQueue(label: "corenavigation.queue", attributes: .concurrent)

public func Present<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> Builder<DestinationType, FromType>) {
    Navigate(.present, to)
}

public func Push<DestinationType: Destination, FromType: UIViewController>(_ to: (To) -> Builder<DestinationType, FromType>) {
    Navigate(.push, to)
}

//public func Present<ToType: UIViewController>(_ to: (To) -> Builder<ToType>) {
//    Navigate(.present, to)
//}
//
//public func Push<ToType: UIViewController>(_ to: (To) -> Builder<ToType>) {
//    Navigate(.push, to)
//}

public func Navigate<DestinationType: Destination, FromType: UIViewController>(_ navigationType: NavigationType, _ to: (To) -> Builder<DestinationType, FromType>) {
    let builder = to(To(navigationType: navigationType, queue: queue))
    
    Navigator(queue: queue).navigate(with: builder.configuration)
}

//public func Navigate<ToType: UIViewController>(_ navigationType: NavigationType, _ to: (To) -> Builder<ToType>) {
//    let builder = to(To(navigationType: navigationType, queue: queue))
//    
//    Navigator(queue: queue).navigate(with: builder.configuration)
//}
