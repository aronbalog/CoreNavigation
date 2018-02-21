import UIKit

public enum StateRestorationBehavior {
    case allow
    case reject
    case protect(protectionSpace: ProtectionSpace, onUnprotect: StateRestorationContext.UnprotectSuccess?, onFailure: StateRestorationContext.UnprotectFailure?)
}

public protocol StateRestorationDelegate {
    func application(_ application: UIApplication, stateRestorationBehaviorForContext context: StateRestorationContext) -> StateRestorationBehavior
}
