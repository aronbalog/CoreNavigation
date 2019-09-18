/// Dismisses visible `UIViewController` instance.
///
/// - Parameters:
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Dismiss<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.dismiss, animated: animated, completion: completion)
}


/// Dismisses given `UIViewController` instance.
///
/// - Parameters:
///   - viewController: An `UIViewController` instance to dismiss
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Dismiss<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.dismiss, viewController: viewController, animated: animated, completion: completion)
}
