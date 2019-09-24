extension Caching {
    class Cache {
        static let instance = Cache()

        private init() {}

        private var items: [String: (UIViewController, UIViewController?)] = [:]

        func removeItem(with cacheIdentifier: String) {
            items.removeValue(forKey: cacheIdentifier)
        }

        func addItem(with cacheIdentifier: String, viewController: UIViewController, embeddingViewController: UIViewController?) {
            items[cacheIdentifier] = (viewController, embeddingViewController)
        }

        func find(with cacheIdentifier: String) -> (UIViewController, UIViewController?)? {
            items[cacheIdentifier]
        }

        func removeAllItems() {
            items = [:]
        }
    }
}
