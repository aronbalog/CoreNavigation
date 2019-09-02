extension Matchable {
    public func viewController() throws -> UIViewController {
        return try Routing.Destination(route: self).viewController()
    }
    
    public func viewController(_ block: @escaping (UIViewController) -> Void, failure: ((Error) -> Void)? = nil) {
        Routing.Destination(route: self).viewController(block, failure)
    }
}
