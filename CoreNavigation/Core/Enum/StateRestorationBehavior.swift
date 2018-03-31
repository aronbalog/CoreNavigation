import Foundation

/// Defines state restoration behaviour.
///
/// - allow: State restoration will be processed.
/// - reject: State restoration will not be processed.
/// - protect: State restoration should be protected with an object conforming ProtectionSpace. Unprotection block from this object must be called on same thread to support state restoration because state restoration engine needs view controller immediately to be able to restore it.
///
/// If you want to handle a case asynchronously, you can use onUnprotect handler in StateRestorationContext where you will be provided with view controller instance. Use it as you wish.
public enum StateRestorationBehavior {
    /// State restoration will be processed.
    case allow
    /// State restoration will not be processed.
    case reject
    /// State restoration should be protected with an object conforming ProtectionSpace. Unprotection block from this object must be called on same thread to support state restoration because state restoration engine needs view controller immediately to be able to restore it.
    case protect(protectionSpace: ProtectionSpace, onUnprotect: StateRestorationContext.UnprotectSuccess?, onFailure: StateRestorationContext.UnprotectFailure?)
}
