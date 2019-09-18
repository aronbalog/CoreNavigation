/// Pops visible `UIViewController` instance from currently presented `UINavigationController`.
///
/// - Parameters:
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Pop<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.pop, animated: animated, completion: completion)
}

/// Pops given `UIViewController` instance from currently presented `UINavigationController`.
///
/// - Parameters:
///   - viewController: An `UIViewController` instance to pop
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Pop<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.pop, viewController: viewController, animated: animated, completion: completion)
}

/// Pops to root `UIViewController` instance in currently presented `UINavigationController`.
///
/// - Parameters:
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func PopToRootViewController<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.popToRootViewController, animated: animated, completion: completion)
}
