public protocol Routable: AnyDestination {
    static func patterns() -> [String]
}
