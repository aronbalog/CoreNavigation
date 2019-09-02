public protocol Destination: AnyDestination {
    associatedtype ViewControllerType: UIViewController
 
    func resolve(with resolver: Resolver<Self>)
}

extension Destination {
    public func resolve(with resolver: Resolver<Self>) {
        resolver.complete(viewController: ViewControllerType.init())
    }
    
    public static func resolveDestination(parameters: [String: Any]?, destination: @escaping (Self) -> Void, failure: @escaping (Error?) -> Void) throws {
        // empty implementation, never gonna happen
    }
    
    public func resolveRouting(with resolver: Resolver<Routing.Destination>) throws {
        // empty implementation, never gonna happen
    }
}
