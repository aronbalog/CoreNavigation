public protocol AnyDestination {
    static func resolve(parameters: [String: Any]?, destination: @escaping (UIViewController) -> Void, failure: @escaping (Error?) -> Void) throws
}

// MARK: - Default implementation of AnyDestination
extension AnyDestination where Self: Routable & Destination {
    public static func resolve(parameters: [String: Any]?, destination: @escaping (UIViewController) -> Void, failure: @escaping (Error?) -> Void) throws {
        self.init(parameters: parameters).resolve(with: Resolver.init(onCompleteBlock: destination, onCancelBlock: failure))
    }
}
