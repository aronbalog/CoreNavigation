import Foundation

/// Describes navigation event.
///
/// - completion->Void: Observes navigation completion.
/// - viewController: Observes view controller events.
public enum NavigationEvent<ToViewController: UIViewController, DataType> {
    /// Observes navigation completion.
    case completion(() -> Void)
    /// Observes view controller events.
    case viewController(ViewControllerEvent<ToViewController>)
}
