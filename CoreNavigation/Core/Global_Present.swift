public func Present<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigate(.present, to)
}

public func Present<ViewControllerType: UIViewController>(viewController: ViewControllerType, animated: Bool = true, completion: ((Navigation.Result<UIViewController.Destination<ViewControllerType>, UIViewController>) -> Void)? = nil) {
    Present { $0
        .to(viewController)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

public func Present<DestinationType: Destination>(destination: DestinationType, animated: Bool = true, completion: ((Navigation.Result<DestinationType, UIViewController>) -> Void)? = nil) {
    Present { $0
        .to(destination)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

