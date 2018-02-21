import UIKit

public protocol Transitionable {
    func animated(_ animated: Bool) -> Self
    func completion(_ completion: @escaping () -> Void) -> Self
    func hidesBottomBarWhenPushed(_ hidesBottomBarWhenPushed: Bool) -> Self
}

public protocol TransitioningDelegatable {
    func transitioningDelegate(_ transitioningDelegate: UIViewControllerTransitioningDelegate?) -> Self
}
