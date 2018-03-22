import UIKit

class Cache {
    static let shared = Cache()
    
    class Storage {
        let viewController: UIViewController
        let lifetime: Lifetime
        
        init(viewController: UIViewController, lifetime: Lifetime) {
            self.viewController = viewController
            self.lifetime = lifetime
        }
    }
    
    private var items: [String: Storage?] = [:]
    
    func add(viewController: UIViewController, lifetime: Lifetime, cacheIdentifier: String) {
        let storage = Storage(viewController: viewController, lifetime: lifetime)

        weak var lifetime = lifetime
        
        lifetime?.die { [weak self] in
            guard let `self` = self else { return }
            
            if
                let _lifetime = self.items[cacheIdentifier]??.lifetime,
                _lifetime === lifetime
            {
                self.items[cacheIdentifier] = nil
            }
        }
        
        items[cacheIdentifier] = storage
    }
    
    func viewController(for cacheIdentifier: String) -> UIViewController? {
        return items[cacheIdentifier]??.viewController
    }
    
    private init() {}
}
