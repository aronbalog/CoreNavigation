/// Pushes resolved `UIViewController` instance to currently presented `UINavigationController` using configuration block.
///
/// - Parameter to: Navigation configuration block
public func Push<DestinationType: Destination, FromType: UIViewController>(_ to: (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Navigate(.push, to)
}

/// Pushes given `UIViewController` instance to currently presented `UINavigationController`.
///
/// - Parameters:
///   - viewController: An `UIViewController` instance to navigate to
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Push<ViewControllerType: UIViewController>(viewController: ViewControllerType, animated: Bool = true, completion: ((Navigation.Result<UIViewController.Destination<ViewControllerType>, UIViewController>) -> Void)? = nil) {
    Push { $0
        .to(viewController)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}

/// Pushes resolved `UIViewController` instance to currently presented `UINavigationController` using an object conforming `Destination` protocol.
///
/// - Parameters:
///   - destination: An object conforming `Destination` protocol to navigate to
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Push<DestinationType: Destination>(destination: DestinationType, animated: Bool = true, completion: ((Navigation.Result<DestinationType, UIViewController>) -> Void)? = nil) {
    Push { $0
        .to(destination)
        .animated(animated)
        .onComplete({ (result) in
            completion?(result)
        })
    }
}
