public func Pop<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.pop, animated: animated, completion: completion)
}

public func Pop<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>(viewController: FromViewControllerType, animated: Bool = true, completion: ((FromViewControllerType, ToViewControllerType) -> Void)? = nil) {
    Close(.pop, viewController: viewController, animated: animated, completion: completion)
}
