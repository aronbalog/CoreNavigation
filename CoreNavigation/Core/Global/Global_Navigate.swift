@discardableResult public func Navigate<BuildableType: Buildable>(_ navigationType: Navigation.Direction.Forward, _ to: (Navigation.To<BuildableType>) -> BuildableType) -> Navigation.Operation {
    Navigator(queue: queue, configuration: to(Navigation.To(navigationType: navigationType, queue: queue)).configuration).navigate()
}

@discardableResult public func Navigate<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To<Navigation.Builder.To<DestinationType, FromType>.Automatic>) -> Navigation.Builder.To<DestinationType, FromType>.Automatic) -> Navigation.Operation {
    Navigate(.automatic, to)
}
