import Foundation

class Navigator {
    static func navigate<T>(with type: NavigationType, configuration: Configuration<T>) {
        switch configuration.destination {
        case .viewController(let viewController):
            switch type {
            case .push:
                push(viewController, with: configuration)
            case .present:
                present(viewController, with: configuration)
            }
        case .routePath(let routePath):
            ()
        case .unknown:
            ()
        }
    }
    
}
