public protocol Destination {
    associatedtype ViewControllerType: UIViewController
 
    func resolve(with resolver: Resolver<Self>)
}

extension Destination {
    public func resolve(with resolver: Resolver<Self>) {
        resolver.complete(viewController: ViewControllerType.init())
    }
}
