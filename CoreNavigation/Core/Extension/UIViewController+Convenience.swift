public extension UIViewController {
    static func from<DestinationType: CoreNavigation.Destination>(destination: DestinationType) throws -> DestinationType.ViewControllerType {
        return try destination.viewController()
    }
}
