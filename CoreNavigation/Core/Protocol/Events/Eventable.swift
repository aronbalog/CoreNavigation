import Foundation

protocol Eventable {
    associatedtype Events: EventAware

    var events: Events { get set }
    
    @discardableResult func on(_ event: Events.NavigationEvent) -> Self
}

extension Configuration: Eventable {
    @discardableResult public func on(_ event: NavigationEvent<ResultableType.ToViewController, ResultableType.DataType>) -> Self {
        events.navigationEvents.append(event)
        
        return self
    }
}
