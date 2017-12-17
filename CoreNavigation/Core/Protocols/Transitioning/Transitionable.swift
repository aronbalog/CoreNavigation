import UIKit

public protocol Transitionable {
    func animated(_ animated: Bool) -> Self
    func completion(_ completion: @escaping () -> Void) -> Self
}

public protocol TransitioningDelegatable {
    func transitioningDelegate(_ transitioningDelegate: UIViewControllerTransitioningDelegate?) -> Self
}
