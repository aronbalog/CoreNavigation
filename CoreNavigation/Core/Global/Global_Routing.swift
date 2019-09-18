/// Registers `Routable` type with the router.
///
/// - Parameter routableType: A type conforming `Routable` protocol
public func Register<RoutableType: Routable>(_ routableType: RoutableType.Type) {
    Routing.Router.instance.register(routableType: routableType)
}

/// Registers `AnyDestination` type and its associated route pattern strings with the router.
///
/// - Parameters:
///   - destinationType: A type conforming `AnyDestination` protocol
///   - patterns: Route pattern strings
public func Register(_ destinationType: AnyDestination.Type, patterns: [String]) {
    Routing.Router.instance.register(destinationType: destinationType, patterns: patterns)
}


/// Unregisters `AnyDestination` type from the router.
///
/// - Parameter destinationType: A type conforming `AnyDestination` protocol
public func Unregister(_ destinationType: AnyDestination.Type) {
    Routing.Router.instance.unregister(destinationType: destinationType)
}


/// Unregisters all destinations matching route pattern string from the router.
///
/// - Parameter pattern: Route pattern string
public func Unregister(matching pattern: String) {
    Routing.Router.instance.unregister(pattern: pattern)
}
