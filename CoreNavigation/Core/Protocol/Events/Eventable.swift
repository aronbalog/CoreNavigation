import Foundation

protocol Eventable {
    associatedtype Events: EventAware

    var events: Events { get set }
    
    @discardableResult func on(_ event: Events.NavigationEvent) -> Self
}

// MARK: - Event observing configuration
extension Configuration: Eventable {
    /// Observe various events defined in `NavigationEvent` enum.
    ///
    /// - Parameter event: `NavigationEvent` enum case.
    /// - Returns: `Configuration` instance.
    @discardableResult public func on(_ event: NavigationEvent<ResultableType.ToViewController, ResultableType.DataType>) -> Self {
        events.navigationEvents.append(event)
        
        return self
    }
}
