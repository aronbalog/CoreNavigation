extension Caching {
    class Builder: Cacheable {
        let block: (Caching.Context) -> Void
        
        init(block: @escaping (Caching.Context) -> Void) {
            self.block = block
        }
        
        init(cachingType: Caching.CachingType) {
            self.block = { context in
                switch cachingType {
                case .time(let timeInterval):
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: context.invalidateCache)
                }
            }
        }
        
        func cache(with context: Caching.Context) {
            block(context)
        }
    }
}
