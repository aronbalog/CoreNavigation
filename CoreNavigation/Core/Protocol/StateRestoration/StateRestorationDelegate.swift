import UIKit

/// Extends iOS state restoration.
public protocol StateRestorationDelegate {
    /// When state restoration is handled through CoreNavigation, on app launch App delegate will be asked to provide behavior for single state restoration case.
    ///
    /// - Parameters:
    ///   - application: `UIApplication` instance.
    ///   - context: `StateRestorationContext` object is used for meta purposes.
    /// - Returns: `StateRestorationBehavior` enum.
    func application(_ application: UIApplication, stateRestorationBehaviorForContext context: StateRestorationContext) -> StateRestorationBehavior
}
