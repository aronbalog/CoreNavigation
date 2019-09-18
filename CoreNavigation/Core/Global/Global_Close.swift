/// Closes visible `UIViewController` instance with given navigation type.
///
/// - Parameters:
///   - navigationType: `Navigation.Direction.Back` enum
///   - back: Navigation configuration block
public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ navigationType: Navigation.Direction.Back, _ back: (Navigation.Back) -> Navigation.Back.Builder<FromViewControllerType, ToViewControllerType>) {
    Navigator(queue: queue).navigate(with: back(Navigation.Back(navigationType: navigationType, queue: queue)).configuration)
}

/// Closes visible `UIViewController` instance with given navigation type.
///
/// - Parameters:
///   - navigationType: `Navigation.Direction.Back` enum
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ navigationType: Navigation.Direction.Back, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(navigationType) { $0
        .visibleViewController()
        .animated(animated)
        .onComplete({ (fromViewController, toViewController) in
            completion?(fromViewController as! FromViewControllerType, toViewController as! ToViewControllerType)
        })
    }
}

/// Closes given `UIViewController` instance with given navigation type.
///
/// - Parameters:
///   - navigationType: `Navigation.Direction.Back` enum
///   - viewController: An `UIViewController` instance to close
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Close<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(_ navigationType: Navigation.Direction.Back, viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(navigationType) { $0
        .viewController(viewController)
        .animated(animated)
        .onComplete({ (fromViewController, toViewController) in
            completion?(fromViewController, toViewController as! ToViewControllerType)
        })
    }
}
