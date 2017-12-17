import UIKit

public protocol ViewControllerEventable {
    @discardableResult
    func loadView(_ loadView: @escaping () -> Void) -> ViewControllerEventable
    
    @discardableResult
    func viewDidLoad(_ viewDidLoad: @escaping () -> Void) -> ViewControllerEventable
    
    @discardableResult
    func viewWillAppear(_ viewWillAppear: @escaping (_ animated: Bool) -> Void) -> ViewControllerEventable
    
    @discardableResult
    func viewDidAppear(_ viewDidAppear: @escaping (_ animated: Bool) -> Void) -> ViewControllerEventable
    
    @discardableResult
    func viewWillDisappear(_ viewWillDisappear: @escaping (_ animated: Bool) -> Void) -> ViewControllerEventable
    
    @discardableResult
    func viewDidDisappear(_ viewDidDisappear: @escaping (_ animated: Bool) -> Void) -> ViewControllerEventable
    
    @discardableResult
    func viewWillTransition(_ viewWillTransition: @escaping (_ toSize: CGSize, _ withCoordinator: UIViewControllerTransitionCoordinator) -> Void) -> ViewControllerEventable
    
    @discardableResult
    func viewWillLayoutSubviews(_ viewWillLayoutSubviews: @escaping () -> Void) -> ViewControllerEventable
    
    @discardableResult
    func viewDidLayoutSubviews(_ viewDidLayoutSubviews: @escaping () -> Void) -> ViewControllerEventable
    
    @discardableResult
    func updateViewConstraints(_ updateViewConstraints: @escaping () -> Void) -> ViewControllerEventable
    
    @discardableResult
    func willMoveTo(_ willMoveTo: @escaping (_ parentViewController: UIViewController?) -> Void) -> ViewControllerEventable
    
    @discardableResult
    func didMoveTo(_ didMoveTo: @escaping (_ parentViewController: UIViewController?) -> Void) -> ViewControllerEventable
    
    @discardableResult
    func didReceiveMemoryWarning(_ didReceiveMemoryWarning: @escaping () -> Void) -> ViewControllerEventable
    
    @discardableResult
    func applicationFinishedRestoringState(_ applicationFinishedRestoringState: @escaping () -> Void) -> ViewControllerEventable
    
    @available(iOS 11.0, *)
    @discardableResult
    func viewLayoutMarginsDidChange(_ viewLayoutMarginsDidChange: @escaping () -> Void) -> ViewControllerEventable
    
    @available(iOS 11.0, *)
    @discardableResult
    func viewSafeAreaInsetsDidChange(_ viewSafeAreaInsetsDidChange: @escaping () -> Void) -> ViewControllerEventable
}
