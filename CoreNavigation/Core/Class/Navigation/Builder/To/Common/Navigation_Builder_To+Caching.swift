extension Navigation.Builder.To {
    @discardableResult public func cache(cacheIdentifier: String, cacheable: Cacheable) -> Self {
        queue.sync { configuration.cachingBlock = { (cacheIdentifier, cacheable) } }

        return self
    }

    @discardableResult public func cache(cacheIdentifier: String, cachingType: Caching.CachingType) -> Self {
        queue.sync { configuration.cachingBlock = { (cacheIdentifier, Caching.Builder(cachingType: cachingType)) } }

        return self
    }

    @discardableResult public func cache(cacheIdentifier: String, _ block: @escaping (Caching.Context) -> Void) -> Self {
        queue.sync { configuration.cachingBlock = { (cacheIdentifier, Caching.Builder(cachingType: .block(block))) } }

        return self
    }
}

extension Navigation.Builder.To where DestinationType: Routing.Destination {
    @discardableResult public func cache(with cacheable: Cacheable) -> Self {
        cache(cacheIdentifier: configuration.destination.route.uri, cacheable: cacheable)
    }

    @discardableResult public func cache(with cachingType: Caching.CachingType) -> Self {
        cache(with: Caching.Builder(cachingType: cachingType))
    }

    @discardableResult public func cache(_ block: @escaping (Caching.Context) -> Void) -> Self {
        cache(with: Caching.Builder(cachingType: .block(block)))
    }
}
