infix operator =>: AdditionPrecedence
infix operator +>: AdditionPrecedence
infix operator <-: AdditionPrecedence

// MARK: present

/// :nodoc:
public func <-(left: AnyDestination.Type, right: [String]) {
    Register(left, patterns: right)
}

/// :nodoc:
public func +> <DestinationType: Destination, FromType: UIViewController>(left: FromType, right: DestinationType) {
    Present { $0.to(right, from: left) }
}

/// :nodoc:
public func +> <DestinationType: Destination, FromType: UIViewController>(left: FromType, right: @escaping (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Present(right)
}

/// :nodoc:
public func +> <ViewControllerType: UIViewController, FromViewController: UIViewController>(left: FromViewController, right: ViewControllerType) {
    Present { $0.to(right, from: left) }
}

// MARK: push

/// :nodoc:
public func => <DestinationType: Destination, FromType: UIViewController>(left: FromType, right: DestinationType) {
    Push { $0.to(right, from: left) }
}

/// :nodoc:
public func => <DestinationType: Destination, FromType: UIViewController>(left: FromType, right: @escaping (Navigation.To) -> Navigation.To.Builder<DestinationType, FromType>) {
    Push(right)
}

/// :nodoc:
public func => <ViewControllerType: UIViewController, FromViewController: UIViewController>(left: FromViewController, right: ViewControllerType) {
    Push { $0.to(right, from: left) }
}

// MARK: pop

/// :nodoc:
public func <= <FromType: UIViewController>(left: FromType, right: Bool) {
    Pop(viewController: left, animated: right)
}

/// :nodoc:
public func <= <FromType: UIViewController, ToType: UIViewController>(left: FromType, right: (Bool, (FromType, ToType) -> Void)) {
    Pop(viewController: left, animated: right.0, completion: right.1)
}

/// :nodoc:
public func <= <FromType: UIViewController, ToType: UIViewController>(left: FromType, right: @escaping ((FromType, ToType) -> Void)) {
    Pop(viewController: left, completion: right)
}

// MARK: dismiss

/// :nodoc:
public func <- <FromType: UIViewController>(left: FromType, right: Bool) {
    Dismiss(viewController: left, animated: right)
}

/// :nodoc:
public func <- <FromType: UIViewController, ToType: UIViewController>(left: FromType, right: (Bool, (FromType, ToType) -> Void)) {
    Dismiss(viewController: left, animated: right.0, completion: right.1)
}

/// :nodoc:
public func <- <FromType: UIViewController, ToType: UIViewController>(left: FromType, right: @escaping ((FromType, ToType) -> Void)) {
    Dismiss(viewController: left, completion: right)
}
