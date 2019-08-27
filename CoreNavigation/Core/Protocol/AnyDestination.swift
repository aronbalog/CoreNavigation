public protocol AnyDestination {
    static func resolve(parameters: [String: Any]?, destination: @escaping (UIViewController) -> Void, failure: @escaping (Error?) -> Void)
}

// MARK: - Default implementation of AnyDestination
extension AnyDestination where Self: Destination {
    /// Resolves destination.
    ///
    /// - Parameters:
    ///   - parameters: Parameters extracted from route's uri.
    ///   - destination: Call this block when resolved and pass viewController and optional data.
    ///   - failure: Call this block and pass optional error to cancel routing.
    public static func resolve(parameters: [String: Any]?, destination: @escaping (UIViewController) -> Void, failure: @escaping (Error?) -> Void) {
        destination(ViewControllerType.init())
    }
}
