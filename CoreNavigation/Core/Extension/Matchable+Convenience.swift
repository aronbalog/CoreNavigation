extension Matchable {
    public func viewController() throws -> UIViewController {
        return try Routing.Destination(route: self).viewController()
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
        return try Routing.Destination(route: self).resolvedDestination().resolvedDestination as! DestinationType
    }
    
    public func present(animated: Bool, completion: ((Navigation.Result<Routing.Destination, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
        return Present { $0
            .to(self)
            .animated(animated)
            .onComplete({ (result) in
                completion?(result)
            })
        }
    }
    
    public func push(animated: Bool, completion: ((Navigation.Result<Routing.Destination, UIViewController>) -> Void)? = nil) -> Navigation.Operation {
        return Push { $0
            .to(self)
            .animated(animated)
            .onComplete({ (result) in
                completion?(result)
            })
        }
    }
}
