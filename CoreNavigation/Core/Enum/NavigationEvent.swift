import Foundation

public enum NavigationEvent {
    case completion(() -> Void)
    case passData((Any) -> Void)
}
