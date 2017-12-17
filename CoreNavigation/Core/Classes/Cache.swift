import Foundation

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
    
    func add(identifier: String, viewController: UIViewController, lifetime: Lifetime) {
        let storage = Storage(viewController: viewController, lifetime: lifetime)
        
        lifetime.die { [weak self] in
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
    
    func viewController(for routePath: String) -> UIViewController? {
        return items[routePath]??.viewController
    }
    
    private init() {}
}
