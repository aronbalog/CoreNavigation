import Foundation

protocol EventAware: class {
    associatedtype NavigationEvent

    var navigationEvents: [NavigationEvent] { get set }
}
