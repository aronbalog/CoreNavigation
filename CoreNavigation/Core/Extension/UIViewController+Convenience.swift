public extension UIViewController {
    static func from<DestinationType: CoreNavigation.Destination>(destination: DestinationType) throws -> DestinationType.ViewControllerType {
        return try destination.viewController()
    }

    static func from(matchable: Matchable) throws -> UIViewController {
        return try matchable.viewController()
    }
}
