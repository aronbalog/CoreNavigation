public func Dismiss<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.dismiss, animated: animated, completion: completion)
}

public func Dismiss<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.dismiss, viewController: viewController, animated: animated, completion: completion)
}
