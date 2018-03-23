import Foundation

extension Navigator {
    static func prepareForStateRestorationIfNeeded<T>(viewController: UIViewController, with configuration: Configuration<T>) {
        let data = configuration.dataPassing.data ?? nil
        let protectionSpace = configuration.protection.protectionSpace
        
        switch configuration.stateRestoration.option {
        case .automatically:
            StateRestoration.prepare(viewController, data: data, protectionSpace: protectionSpace)
        case .automaticallyWithIdentifier(let restorationIdentifier):
            StateRestoration.prepare(viewController, identifier: restorationIdentifier, data: data, protectionSpace: protectionSpace)
        case .manually(let restorationIdentifier, let restorationClass):
            viewController.restorationIdentifier = restorationIdentifier
            viewController.restorationClass = restorationClass
        default:
            ()
        }
        
    }
}
