import Foundation

/// :nodoc:
public enum ViewControllerEvent<T: UIViewController> {
    case loadView((_ viewController: T) -> Void)
    case viewDidLoad((_ viewController: T) -> Void)
    case viewWillAppear((_ viewController: T, _ animated: Bool) -> Void)
    case viewDidAppear((_ viewController: T, _ animated: Bool) -> Void)
    case viewWillDisappear((_ viewController: T, _ animated: Bool) -> Void)
    case viewDidDisappear((_ viewController: T, _ animated: Bool) -> Void)
    case viewWillTransition((_ viewController: T, _ size: CGSize, _ coordinator: UIViewControllerTransitionCoordinator) -> Void)
    case viewWillLayoutSubviews((_ viewController: T) -> Void)
    case viewDidLayoutSubviews((_ viewController: T) -> Void)
    case updateViewConstraints((_ viewController: T) -> Void)
    case willMoveTo((_ viewController: T, _ parentViewController: UIViewController?) -> Void)
    case didMoveTo((_ viewController: T, _ parentViewController: UIViewController?) -> Void)
    case didReceiveMemoryWarning((_ viewController: T) -> Void)
    case applicationFinishedRestoringState((_ viewController: T) -> Void)

    @available(iOS 11.0, *) case viewLayoutMarginsDidChange((_ viewController: T) -> Void)
    @available(iOS 11.0, *) case viewSafeAreaInsetsDidChange((_ viewController: T) -> Void)
}
