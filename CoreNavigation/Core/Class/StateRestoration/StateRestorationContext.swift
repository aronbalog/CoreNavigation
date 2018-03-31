import UIKit

/// Object containing essential informations about state restoration in progress.
public class StateRestorationContext {
    public typealias UnprotectSuccess = (UIViewController) -> Void
    public typealias UnprotectFailure = (Error) -> Void
    
    /// State restoration identifier.
    public let restorationIdentifier: String
    
    /// State restoration view controller class.
    public let viewControllerClass: UIViewController.Type
    
    /// Protection space class.
    public let protectionSpaceClass: AnyClass?
    
    /// Passed data.
    public let data: Any?
    
    var unprotectSuccess: UnprotectSuccess?
    var unprotectFailure: UnprotectFailure?
    
    init(restorationIdentifier: String, viewControllerClass: UIViewController.Type, protectionSpaceClass: AnyClass?, data: Any?) {
        self.restorationIdentifier = restorationIdentifier
        self.viewControllerClass = viewControllerClass
        self.protectionSpaceClass = protectionSpaceClass
        self.data = data
    }
    
    /// Observes unprotect.
    ///
    /// - Parameter success: Unprotection success block.
    public func onUnprotect(_ success: @escaping UnprotectSuccess) {
        self.unprotectSuccess = success
    }
    
    /// Observes protection failure.
    ///
    /// - Parameter failure: Uprotection failure block.
    public func onFailure(_ failure: @escaping UnprotectFailure) {
        self.unprotectFailure = failure
    }
}
