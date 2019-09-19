/// Dismisses visible `UIViewController` instance.
///
/// - Parameters:
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Dismiss<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) -> Navigation.Operation {
    return Close(.dismiss, animated: animated, completion: completion)
}

/// Dismisses given `UIViewController` instance.
///
/// - Parameters:
///   - viewController: An `UIViewController` instance to dismiss
///   - animated: A flag indicating whether navigation is animated
///   - completion: Completion block
public func Dismiss<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) -> Navigation.Operation {
    return Close(.dismiss, viewController: viewController, animated: animated, completion: completion)
}

// MARK: Operators

/// :nodoc:
public func <<< <FromType: UIViewController>(left: FromType, right: Bool) -> Navigation.Operation {
    return Dismiss(viewController: left, animated: right)
}

/// :nodoc:
public func <<< <FromType: UIViewController, ToType: UIViewController>(left: FromType, right: (Bool, (FromType, ToType) -> Void)) -> Navigation.Operation {
    return Dismiss(viewController: left, animated: right.0, completion: right.1)
}

/// :nodoc:
public func <<< <FromType: UIViewController, ToType: UIViewController>(left: FromType, right: @escaping ((FromType, ToType) -> Void)) -> Navigation.Operation {
    return Dismiss(viewController: left, completion: right)
}
