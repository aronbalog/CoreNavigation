import UIKit

public enum StateRestorationBehavior {
    case allow
    case reject
    case protect(protectionSpace: ProtectionSpace)
}

public protocol StateRestorationDelegate {
    func application(_ application: UIApplication, stateRestorationBehaviorForContext context: StateRestorationContext) -> StateRestorationBehavior
}
