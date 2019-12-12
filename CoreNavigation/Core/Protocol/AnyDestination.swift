public protocol AnyDestination {
    static func resolveDestination(parameters: [String: Any]?, uri: String, pattern: String, destination: @escaping (Self) -> Void, failure: @escaping (Error) -> Void) throws
    func resolveRouting(with resolver: Resolver<Routing.Destination>) throws
}

extension AnyDestination where Self: UIViewController & Routable {
    public static func resolveDestination(parameters: [String: Any]?, uri: String, pattern: String, destination: @escaping (Self) -> Void, failure: @escaping (Error) -> Void) throws {
        func execute() throws {
            destination(try .init(parameters: parameters, uri: uri, pattern: pattern))
        }
        if Thread.isMainThread {
            try execute()
        } else {
            try DispatchQueue.main.sync {
                try execute()
            }
        }
    }

    public func resolveRouting(with resolver: Resolver<Routing.Destination>) throws {
        resolver.complete(viewController: self)
    }
}
