public func Push<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigate(.push, to)
}

public func Push<ViewControllerType: UIViewController>(viewController: ViewControllerType, animated: Bool = true, completion: ((Navigation.Result<UIViewController.Destination<ViewControllerType>, UIViewController>) -> Void)? = nil) {
    Push { $0
        .to(viewController)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

public func Push<DestinationType: Destination>(destination: DestinationType, animated: Bool = true, completion: ((Navigation.Result<DestinationType, UIViewController>) -> Void)? = nil) {
    Push { $0
        .to(destination)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

