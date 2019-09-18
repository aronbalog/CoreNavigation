public protocol AnyDestination {
    static func resolveDestination(parameters: [String: Any]?, destination: @escaping (Self) -> Void, failure: @escaping (Error) -> Void) throws
    func resolveRouting(with resolver: Resolver<Routing.Destination>) throws
}

extension AnyDestination where Self: UIViewController & Routable {
    public static func resolveDestination(parameters: [String: Any]?, destination: @escaping (Self) -> Void, failure: @escaping (Error) -> Void) throws {
        destination(.init(parameters: parameters))
    }

    public func resolveRouting(with resolver: Resolver<Routing.Destination>) throws {
        resolver.complete(viewController: self)
    }
}
