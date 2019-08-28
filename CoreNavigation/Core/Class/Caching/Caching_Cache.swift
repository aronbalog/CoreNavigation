extension Caching {
    class Cache {
        static let instance = Cache()
        
        private init() {}
        
        private var items: [String: (UIViewController, UIViewController?)] = [:]
        
        func removeItem(with cacheIdentifier: String) {
            items[cacheIdentifier] = nil
        }
        
        func addItem(with cacheIdentifier: String, viewController: UIViewController, embeddingViewController: UIViewController?) {
            items[cacheIdentifier] = (viewController, embeddingViewController)
        }
        
        func find(with cacheIdentifier: String) -> (UIViewController, UIViewController?)? {
            return items[cacheIdentifier]
        }
    }
}
