import UIKit

class StateRestoration: UIViewControllerRestoration {
    
    @objc(StateRestorationStorageItem) class StorageItem: NSObject, NSCoding {
        let identifier: String
        let viewControllerClass: UIViewController.Type
        let parameters: [String: Any]?
        let protectionSpaceClass: AnyClass?
        
        enum CodingKeys: CodingKey {
            case identifier
            case viewControllerClass
            case parameters
            case protectionSpaceClass
        }
        
        init(identifier: String, viewControllerClass: UIViewController.Type, parameters: [String: Any]?, protectionSpaceClass: ProtectionSpace.Type?) {
            self.identifier = identifier
            self.viewControllerClass = viewControllerClass
            self.parameters = parameters
            self.protectionSpaceClass = protectionSpaceClass
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(identifier, forKey: "identifier")
            aCoder.encode(NSStringFromClass(viewControllerClass), forKey: "viewControllerClass")
            if let parameters = parameters {
                aCoder.encode(parameters, forKey: "parameters")
            }
            if let protectionSpaceClass = protectionSpaceClass {
                aCoder.encode(NSStringFromClass(protectionSpaceClass), forKey: "protectionSpaceClass")
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.identifier = aDecoder.decodeObject(forKey: "identifier") as! String
            
            let viewControllerClassString = aDecoder.decodeObject(forKey: "viewControllerClass") as! String
            self.viewControllerClass = NSClassFromString(viewControllerClassString) as! UIViewController.Type
            
            self.parameters = aDecoder.decodeObject(forKey: "parameters") as? [String: Any]
            
            if let protectionSpaceClassString = aDecoder.decodeObject(forKey: "protectionSpaceClass") as? String {
                self.protectionSpaceClass = NSClassFromString(protectionSpaceClassString)
            } else {
                self.protectionSpaceClass = nil
            }
        }
    }
    
    private static let storageIdentifier = "CoreNavigation.StateRestoration"

    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        
        print("Components: ", identifierComponents)
        
        guard let identifier = identifierComponents.last as? String else { return nil }
        guard let storageItem = find(identifier: identifier) else {
            print("Restoration \(identifier) not found")
            return nil }
        guard let delegate = UIApplication.shared.delegate as? StateRestorationDelegate else {
            fatalError("App delegate must conform `StateRestorationDelegate`")
        }
        
        var viewController: UIViewController?
        
        let context = StateRestorationContext(restorationIdentifier: identifier, viewControllerClass: storageItem.viewControllerClass, protectionSpaceClass: storageItem.protectionSpaceClass, parameters: storageItem.parameters)
        
        let behavior = delegate.application(UIApplication.shared, stateRestorationBehaviorForContext: context)
        switch behavior {
        case .reject:
            return nil
        case .allow:
            viewController = action(storageItem: storageItem)
            
            return viewController
        case .protect(let protectionSpace):
            if protectionSpace.shouldProtect(unprotect: {
                viewController = action(storageItem: storageItem)
                
                if let viewController = viewController {
                    context.unprotectSuccess?(viewController)
                }
            }, failure: { (error) in
                viewController = nil
                context.unprotectFailure?(error)
            }) == false {
                viewController = action(storageItem: storageItem)
            }
            
            return viewController
        }
    }
    
    static private func action(storageItem: StorageItem) -> UIViewController {
        let viewController = storageItem.viewControllerClass.init(nibName: nil, bundle: nil)
        viewController.restorationIdentifier = storageItem.identifier
        viewController.restorationClass = StateRestoration.self
        
        if let viewController = viewController as? ResponseAware {
            let response = Response<UIViewController, UIViewController, UIViewController>(fromViewController: nil, toViewController: nil, embeddingViewController: nil)
            
            response.parameters = storageItem.parameters
            
            viewController.didReceiveResponse(response)
        }
        
        return viewController
    }
    
    static func prepare(_ viewController: UIViewController, identifier: String?, parameters: [String: Any]?, protectionSpace: ProtectionSpace?) {
        
        let identifier = identifier ?? UUID().uuidString
        
        viewController.restorationIdentifier = identifier
        viewController.restorationClass = StateRestoration.self
        
        let protectionSpaceClass: ProtectionSpace.Type? = {
            guard let protectionSpace = protectionSpace else { return nil }
            
            return type(of: protectionSpace)
        }()

        var _parameters: [String: Any]? = [:]
        
        parameters?.forEach({ (object) in
            if object.value is NSCoding {
                _parameters?[object.key] = object.value
            }
        })
        
        if _parameters?.isEmpty == true {
            _parameters = nil
        }
        
        let storageItem = StorageItem(identifier: identifier, viewControllerClass: type(of: viewController), parameters: _parameters, protectionSpaceClass: protectionSpaceClass)
        
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
