import Foundation

/// Describes navigation event.
///
/// - completion->Void: Observes navigation completion.
/// - passData->Void: Observes passing data to view controller.
/// - viewController: Observes view controller events.
public enum NavigationEvent<ToViewController: UIViewController, DataType> {
    /// Observes navigation completion.
    case completion(() -> Void)
    /// Observes passing data to view controller.
    case passData((DataType) -> Void)
    /// Observes view controller events.
    case viewController(ViewControllerEvent<ToViewController>)
}
