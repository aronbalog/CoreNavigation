import Foundation

public enum ViewControllerEvent {
    case loadView(() -> Void)
    case viewDidLoad(() -> Void)
    case viewWillAppear((Bool) -> Void)
    case viewDidAppear((Bool) -> Void)
    case viewWillDisappear((Bool) -> Void)
    case viewDidDisappear((Bool) -> Void)
    case viewWillTransition((CGSize, UIViewControllerTransitionCoordinator) -> Void)
    case viewWillLayoutSubviews(() -> Void)
    case viewDidLayoutSubviews(() -> Void)
    case updateViewConstraints(() -> Void)
    case willMoveTo((UIViewController?) -> Void)
    case didMoveTo((UIViewController?) -> Void)
    case didReceiveMemoryWarning(() -> Void)
    case applicationFinishedRestoringState(() -> Void)
    
    @available(iOS 11.0, *) case viewLayoutMarginsDidChange(() -> Void)
    @available(iOS 11.0, *) case viewSafeAreaInsetsDidChange(() -> Void)
}
