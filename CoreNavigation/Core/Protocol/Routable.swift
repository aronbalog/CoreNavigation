public protocol Routable: AnyDestination {
    static func routePatterns() -> [String]
    init(parameters: [String: Any]?)
}
