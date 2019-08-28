public protocol Cacheable {
    func cache(with context: Caching.Context)
}
