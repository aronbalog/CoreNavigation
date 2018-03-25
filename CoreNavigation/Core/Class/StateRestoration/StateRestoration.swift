import UIKit

class StateRestoration: UIViewControllerRestoration {
    
    @objc(StateRestorationStorageItem) class StorageItem: NSObject, NSCoding {
        let identifier: String
        let viewControllerClass: UIViewController.Type
        let data: Any?
        let protectionSpaceClass: ProtectionSpace.Type?
        
        enum CodingKeys: CodingKey {
            case identifier
            case viewControllerClass
            case parameters
            case protectionSpaceClass
        }
        
        init(identifier: String, viewControllerClass: UIViewController.Type, data: Any?, protectionSpaceClass: ProtectionSpace.Type?) {
            self.identifier = identifier
            self.viewControllerClass = viewControllerClass
            self.data = data
            self.protectionSpaceClass = protectionSpaceClass
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(identifier, forKey: "identifier")
            aCoder.encode(NSStringFromClass(viewControllerClass), forKey: "viewControllerClass")
            if let data = data {
                aCoder.encode(data, forKey: "data")
            }
            if let protectionSpaceClass = protectionSpaceClass {
                aCoder.encode(NSStringFromClass(protectionSpaceClass), forKey: "protectionSpaceClass")
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.identifier = aDecoder.decodeObject(forKey: "identifier") as! String
            
            let viewControllerClassString = aDecoder.decodeObject(forKey: "viewControllerClass") as! String
            self.viewControllerClass = NSClassFromString(viewControllerClassString) as! UIViewController.Type
            
            self.data = aDecoder.decodeObject(forKey: "data")
            
            if let protectionSpaceClassString = aDecoder.decodeObject(forKey: "protectionSpaceClass") as? String {
                self.protectionSpaceClass = NSClassFromString(protectionSpaceClassString) as? ProtectionSpace.Type
            } else {
                self.protectionSpaceClass = nil
            }
        }
    }
    
    private static let storageIdentifier = "CoreNavigation.StateRestoration"
    
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        guard let identifier = identifierComponents.last as? String else { return nil }
        guard let storageItem = find(identifier: identifier) else { return nil }
        guard let delegate = UIApplication.shared.delegate as? StateRestorationDelegate else {
            fatalError("App delegate must conform `StateRestorationDelegate`")
        }
        
        var viewController: UIViewController?
        
        let context = StateRestorationContext(restorationIdentifier: identifier, viewControllerClass: storageItem.viewControllerClass, protectionSpaceClass: storageItem.protectionSpaceClass, data: storageItem.data)
        
        let behavior = delegate.application(UIApplication.shared, stateRestorationBehaviorForContext: context)
        switch behavior {
        case .reject:
            return nil
        case .allow:
            viewController = action(storageItem: storageItem)
            
            return viewController
        case .protect(let protectionSpace, let onUnprotect, let onFailure):
            if protectionSpace.shouldProtect() {
                let handler = ProtectionHandler()
                protectionSpace.protect(handler)
                
                handler.onUnprotect {
                    viewController = action(storageItem: storageItem)
                    
                    if let viewController = viewController {
                        context.unprotectSuccess?(viewController)
                        onUnprotect?(viewController)
                    }
                }
            } else {
                viewController = action(storageItem: storageItem)
            }
           
            return viewController
        }
    }
    
    static private func action(storageItem: StorageItem) -> UIViewController {
        let viewController = storageItem.viewControllerClass.init()
        viewController.restorationIdentifier = storageItem.identifier
        viewController.restorationClass = StateRestoration.self
        
        if
            let viewController = viewController as? DataReceiving,
            let data = storageItem.data
        {
            viewController.didReceiveAbstractData(data)
        }
        
        return viewController
    }
    
    static func prepare(_ viewController: UIViewController, identifier: String = UUID().uuidString, data: Any?, protectionSpace: ProtectionSpace?) {
        
        viewController.restorationIdentifier = identifier
        viewController.restorationClass = StateRestoration.self
        
        let protectionSpaceClass: ProtectionSpace.Type? = {
            guard let protectionSpace = protectionSpace else { return nil }
            
            return type(of: protectionSpace)
        }()
        
        let storageItem = StorageItem(identifier: identifier, viewControllerClass: type(of: viewController), data: data, protectionSpaceClass: protectionSpaceClass)
        
        store(storageItem)
    }
    
    
    private static func find(identifier: String) -> StorageItem? {
        guard let data = UserDefaults.standard.object(forKey: storageIdentifier(for: identifier)) as? Data else { return nil }
        
        let item = NSKeyedUnarchiver.unarchiveObject(with: data) as? StorageItem
        
        return item
    }
    
    private static func store(_ storageItem: StorageItem) {
        let data = NSKeyedArchiver.archivedData(withRootObject: storageItem)
        UserDefaults.standard.set(data, forKey: storageIdentifier(for: storageItem.identifier))
        
        UserDefaults.standard.synchronize()
    }
    
    private static func storageIdentifier(for identifier: String) -> String {
        return storageIdentifier + "." + identifier
    }
}

