public protocol AnyDestination {
    static func resolveDestination(parameters: [String: Any]?, destination: @escaping (Self) -> Void, failure: @escaping (Error?) -> Void) throws
    func resolveRouting(with resolver: Resolver<Routing.Destination>)
}

// MARK: - Default implementation of AnyDestination
extension AnyDestination where Self: Routable & Destination {
    public static func resolveDestination(parameters: [String: Any]?, destination: @escaping (Self) -> Void, failure: @escaping (Error?) -> Void) throws {
        destination(self.init(parameters: parameters))
    }
    public func resolveRouting(with resolver: Resolver<Routing.Destination>) {
        resolve(with: Resolver<Self>.init(onCompleteBlock: resolver.onCompleteBlock, onCancelBlock: resolver.onCancelBlock))
    }
}
