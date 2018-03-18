import UIKit

public class StateRestorationContext {
    public typealias UnprotectSuccess = (UIViewController) -> Void
    public typealias UnprotectFailure = (Error) -> Void
    
    public let restorationIdentifier: String
    public let viewControllerClass: UIViewController.Type
    public let protectionSpaceClass: AnyClass?
    public let data: Any?
    
    var unprotectSuccess: UnprotectSuccess?
    var unprotectFailure: UnprotectFailure?
    
    init(restorationIdentifier: String, viewControllerClass: UIViewController.Type, protectionSpaceClass: AnyClass?, data: Any?) {
        self.restorationIdentifier = restorationIdentifier
        self.viewControllerClass = viewControllerClass
        self.protectionSpaceClass = protectionSpaceClass
        self.data = data
    }
    
    public func onUnprotect(_ success: @escaping UnprotectSuccess) {
        self.unprotectSuccess = success
    }
    
    public func onFailure(_ failure: @escaping UnprotectFailure) {
        self.unprotectFailure = failure
    }
}
