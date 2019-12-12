public protocol Destination: AnyDestination {
    associatedtype ViewControllerType: UIViewController

    func resolve(with resolver: Resolver<Self>)
    func didResolve(viewController: ViewControllerType)
}

extension Destination {
    public func resolve(with resolver: Resolver<Self>) {
        let viewController: ViewControllerType = {
            switch Thread.isMainThread {
            case true:
                return ViewControllerType()
            case false:
                return DispatchQueue.main.sync {
                    return ViewControllerType()
                }
            }
        }()
        
        resolver.complete(viewController: viewController)
    }

    public static func resolveDestination(parameters: [String: Any]?, uri: String, pattern: String, destination: @escaping (Self) -> Void, failure: @escaping (Error) -> Void) throws {
        // empty implementation, never gonna happen if destination conforms to Routable
    }

    public func resolveRouting(with resolver: Resolver<Routing.Destination>) throws {
        // empty implementation, never gonna happen if destination conforms to Routable
    }
    
    public func didResolve(viewController: ViewControllerType) {
        // empty implementation
    }
}

extension Destination where Self: Routable {
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
        resolve(with: Resolver<Self>.init(onCompleteBlock: resolver.onCompleteBlock, onCancelBlock: resolver.onCancelBlock))
    }
}
