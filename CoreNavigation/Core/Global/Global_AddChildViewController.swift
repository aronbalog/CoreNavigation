/// Adds resolved `UIViewController` instance as child view controller to currently presented `UIViewController` using configuration block.
///
/// - Parameter to: Configuration block
public func AddChildViewController<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigate(.childViewController, to)
}
