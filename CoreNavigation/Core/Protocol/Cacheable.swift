public protocol Cacheable {
    func didCache(with context: Caching.Context)
}
