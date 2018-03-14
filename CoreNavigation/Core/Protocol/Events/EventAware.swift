import Foundation

public protocol EventAware: class {
    var navigationEvents: [NavigationEvent] { get set }
}
