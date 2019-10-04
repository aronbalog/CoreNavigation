/// Adds resolved `UIViewController` instance as child view controller to currently presented `UIViewController` using configuration block.
///
/// - Parameter to: Configuration block
@discardableResult public func AddChildViewController<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To<Navigation.Builder.To<DestinationType, FromType>>) -> Navigation.Builder.To<DestinationType, FromType>) -> Navigation.Operation {
    Navigate(.childViewController, to)
}
