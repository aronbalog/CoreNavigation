/// Clears navigation cache.
public func ClearCache() {
    Caching.Cache.instance.removeAllItems()
}

/// Clears navigation cache with given cache identifier.
///
/// - Parameter identifier: Cache identifier string
public func RemoveFromCache(with identifier: String) {
    Caching.Cache.instance.removeItem(with: identifier)
}
