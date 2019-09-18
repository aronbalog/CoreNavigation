extension Navigator {
    func resolveFromCache<DestinationType: Destination>(
        _ destination: DestinationType,
        cacheIdentifier: String,
        success: @escaping (DestinationType, DestinationType.ViewControllerType, UIViewController?) -> Void,
        failure: @escaping () -> Void) {
        guard
            let items = self.cache.find(with: cacheIdentifier),
            let destinationViewController = items.0 as? DestinationType.ViewControllerType
            else {
                failure()
                return
        }
        success(destination, destinationViewController, items.1)
    }
    func cache(
        cacheIdentifier: String,
        cacheable: Cacheable,
        viewController: UIViewController,
        embeddingViewController: UIViewController?) {
        queue.sync {
            self.cache.addItem(with: cacheIdentifier, viewController: viewController, embeddingViewController: embeddingViewController)
        }
        cacheable.didCache(with: Caching.Context(cacheIdentifier: cacheIdentifier, onInvalidateBlock: {
            self.queue.sync {
                self.cache.removeItem(with: cacheIdentifier)
            }
        }))
    }
}
