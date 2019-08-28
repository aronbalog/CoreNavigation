extension Caching {
    public class Context {
        public let cacheIdentifier: String
        private let onInvalidateBlock: () -> Void
        
        init(cacheIdentifier: String, onInvalidateBlock: @escaping () -> Void) {
            self.cacheIdentifier = cacheIdentifier
            self.onInvalidateBlock = onInvalidateBlock
        }
        
        public func invalidateCache() {
            onInvalidateBlock()
        }
    }
}
