extension Caching {
    class Builder: Cacheable {
        let block: (Caching.Context) -> Void
        
        init(block: @escaping (Caching.Context) -> Void) {
            self.block = block
        }
        
        func cache(with context: Caching.Context) {
            block(context)
        }
    }
}
