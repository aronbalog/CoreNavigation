extension Caching {
    class Builder: Cacheable {
        let block: (Caching.Context) -> Void
        
        init(cachingType: Caching.CachingType) {
            self.block = { context in
                switch cachingType {
                case .timeInterval(let timeInterval):
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: context.invalidateCache)
                case .block(let block):
                    block(context)
                }
            }
        }
        
        func didCache(with context: Caching.Context) {
            block(context)
        }
    }
}
