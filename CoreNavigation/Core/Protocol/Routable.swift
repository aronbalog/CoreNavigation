public protocol Routable: AnyDestination {
    static func patterns() -> [String]
    init(parameters: [String: Any]?)
}
