import Foundation

/// Tracks keyboard and affects app window.
///
/// - rise: Rises window above keyboard without changing its size.
/// - shrink: Shrinks window above keyboard.
/// - `default`: Default behaviour.
public enum KeyboardTrackingMode {
    /// Rises window above keyboard without changing its size.
    case rise
    /// Shrinks window above keyboard.
    case shrink
    /// Default behaviour.
    case `default`
}
