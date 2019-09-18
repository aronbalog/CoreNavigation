/// Navigates to resolved `UIViewController` instance with given navigation type using configuration block.
///
/// - Parameters:
///   - navigationType: `Navigation.Direction.Forward` enum
///   - to: Navigation configuration block
public func Navigate<DestinationType: Destination, FromType: UIViewController>(_ navigationType: Navigation.Direction.Forward, _ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigator(queue: queue).navigate(with: to(Navigation.To(navigationType: navigationType, queue: queue)).configuration)
}
