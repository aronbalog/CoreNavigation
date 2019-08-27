public protocol Destination: AnyDestination {
    associatedtype ViewControllerType: UIViewController
 
    func resolve(with resolver: Resolver<Self>)
}

extension Destination {
    public func resolve(with resolver: Resolver<Self>) {
        resolver.complete(viewController: ViewControllerType.init())
    }
}

extension String: Matchable {
    public var uri: String {
        return self
    }
}
