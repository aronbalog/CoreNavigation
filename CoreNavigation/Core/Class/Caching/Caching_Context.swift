extension Caching {
    /// Caching context. Use it to invalidate cache.
    public class Context {
        /// Cache identifier provided upon the navigation.
        public let cacheIdentifier: String
        private let onInvalidateBlock: () -> Void
        
        init(cacheIdentifier: String, onInvalidateBlock: @escaping () -> Void) {
            self.cacheIdentifier = cacheIdentifier
            self.onInvalidateBlock = onInvalidateBlock
        }
        
        /// Invalidates cache.
        public func invalidateCache() {
            onInvalidateBlock()
        }
    }
}
