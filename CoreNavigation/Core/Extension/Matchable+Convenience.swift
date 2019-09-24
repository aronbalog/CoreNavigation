extension Matchable {
    public func viewController() throws -> UIViewController {
        try Routing.Destination(route: self).viewController()
    }

    public func viewController(_ block: @escaping (UIViewController) -> Void, failure: ((Error) -> Void)? = nil) {
        Routing.Destination(route: self).viewController(block, failure)
    }

    public func destination<DestinationType: Destination>(_ block: @escaping (DestinationType) -> Void, failure: ((Error) -> Void)? = nil) {
        Routing.Destination(route: self).resolvedDestination({ (destination) in
            block(destination.resolvedDestination as! DestinationType)
        }, failure)
    }

    public func destination<DestinationType: Destination>() throws -> DestinationType {
        try Routing.Destination(route: self).resolvedDestination().resolvedDestination as! DestinationType
    }
    
    @discardableResult public func navigate<FromType: UIViewController>(_ navigationType: Navigation.Direction.Forward, _ to: (Navigation.To.Builder<Routing.Destination, FromType>) -> Navigation.To.Builder<Routing.Destination, FromType>) -> Navigation.Operation {
        Navigate(navigationType, { to($0.to(self)) })
    }
    
    @discardableResult public func present(animated: Bool = true, completion: ((Navigation.Result<Routing.Destination, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
        navigate(.present, { $0
            .animated(animated)
            .onComplete({ (result) in
                completion?(result)
            })
        })
    }
    
    @discardableResult public func push(animated: Bool = true, completion: ((Navigation.Result<Routing.Destination, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
        navigate(.push, { $0
            .animated(animated)
            .onComplete({ (result) in
                completion?(result)
            })
        })
    }
    
    @discardableResult public func present<FromType: UIViewController>(_ to: (Navigation.To.Builder<Routing.Destination, FromType>) -> Navigation.To.Builder<Routing.Destination, FromType>) -> Navigation.Operation {
        navigate(.present, to)
    }
    
    @discardableResult public func push<FromType: UIViewController>(_ to: (Navigation.To.Builder<Routing.Destination, FromType>) -> Navigation.To.Builder<Routing.Destination, FromType>) -> Navigation.Operation {
        navigate(.push, to)
    }
}
