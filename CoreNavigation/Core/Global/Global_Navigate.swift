/// Navigates to resolved `UIViewController` instance with given navigation type using configuration block.
///
/// - Parameters:
///   - navigationType: `Navigation.Direction.Forward` enum
///   - to: Navigation configuration block
@discardableResult public func Navigate<BuildableType: Buildable>(_ navigationType: Navigation.Direction.Forward, _ to: (Navigation.To<BuildableType>) -> BuildableType) -> Navigation.Operation {
    Navigator(queue: queue, configuration: to(Navigation.To(navigationType: navigationType, queue: queue)).configuration).navigate()
}
