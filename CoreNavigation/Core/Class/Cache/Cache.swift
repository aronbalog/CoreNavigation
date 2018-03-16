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
    
    func add(viewController: UIViewController, lifetime: Lifetime) {
        let storage = Storage(viewController: viewController, lifetime: lifetime)

        let identifier = lifetime.cacheIdentifier()

        weak var lifetime = lifetime
        
        lifetime?.die { [weak self] in
            guard let `self` = self else { return }
            
            if
                let _lifetime = self.items[identifier]??.lifetime,
                _lifetime === lifetime
            {
                self.items[identifier] = nil
            }
        }
        
        items[identifier] = storage
    }
    
    func viewController(for identifier: String) -> UIViewController? {
        return items[identifier]??.viewController
    }
    
    private init() {}
}
