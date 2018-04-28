import Foundation

extension Navigator {
    static func cacheViewControllerIfNeeded<T>(viewController: UIViewController, with configuration: Configuration<T>) {
        guard let configuration = configuration.caching.configuration else { return }

        Cache.shared.add(viewController: viewController, lifetime: configuration.lifetime, cacheIdentifier: configuration.cacheIdentifier)
    }
}
