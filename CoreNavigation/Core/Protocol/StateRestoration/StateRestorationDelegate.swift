import UIKit

/// <#Description#>
///
/// - allow: <#allow description#>
/// - reject: <#reject description#>
/// - protect: <#protect description#>
public enum StateRestorationBehavior {
    case allow
    case reject
    case protect(protectionSpace: ProtectionSpace, onUnprotect: StateRestorationContext.UnprotectSuccess?, onFailure: StateRestorationContext.UnprotectFailure?)
}

/// <#Description#>
public protocol StateRestorationDelegate {
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - application: <#application description#>
    ///   - context: <#context description#>
    /// - Returns: <#return value description#>
    func application(_ application: UIApplication, stateRestorationBehaviorForContext context: StateRestorationContext) -> StateRestorationBehavior
}
