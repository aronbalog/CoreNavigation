import UIKit

class StateRestoration: UIViewControllerRestoration {
    struct StorageItem: Codable {
        let identifier: String
        let viewControllerClass: UIViewController.Type
        let parameters: Data?
        let protectionSpaceClass: AnyClass?
        
        enum CodingKeys: CodingKey {
            case identifier
            case viewControllerClass
            case parameters
            case protectionSpaceClass
        }
        
        init(identifier: String, viewControllerClass: UIViewController.Type, parameters: Data?, protectionSpaceClass: ProtectionSpace.Type?) {
            self.identifier = identifier
            self.viewControllerClass = viewControllerClass
            self.parameters = parameters
            self.protectionSpaceClass = protectionSpaceClass
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            identifier = try container.decode(String.self, forKey: .identifier)
            
            let viewControllerClassString = try container.decode(String.self, forKey: .viewControllerClass)
            viewControllerClass = NSClassFromString(viewControllerClassString) as! UIViewController.Type

            parameters = try container.decodeIfPresent(Data.self, forKey: .parameters)
            
            if let protectionSpaceClassString = try container.decodeIfPresent(String.self, forKey: .viewControllerClass) {
                protectionSpaceClass = NSClassFromString(protectionSpaceClassString)
            } else {
                protectionSpaceClass = nil
            }
            
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(identifier, forKey: .identifier)
            let viewControllerClassString = NSStringFromClass(self.viewControllerClass)
            try container.encode(viewControllerClassString, forKey: .viewControllerClass)
            try container.encodeIfPresent(parameters, forKey: .parameters)
            if let protectionSpaceClass = self.protectionSpaceClass {
                let protectionSpaceClassString = NSStringFromClass(protectionSpaceClass)
                try container.encodeIfPresent(protectionSpaceClassString, forKey: .protectionSpaceClass)
            }
        }
        
        func parametersDictionary() -> [String: Any]? {
            guard let parameters = parameters else { return nil }
        
            let jsonObject = try? JSONSerialization.jsonObject(with: parameters, options: [])
            
            return (jsonObject as? [String: Any]) ?? nil
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
        
        let context = StateRestorationContext(restorationIdentifier: identifier, viewControllerClass: storageItem.viewControllerClass, protectionSpaceClass: storageItem.protectionSpaceClass, parameters: storageItem.parametersDictionary())
        
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
            
            if
                let data = storageItem.parameters,
                let parameters = try? JSONSerialization.jsonObject(with: data, options: []) {
                response.parameters = parameters as? [String: Any]
            }
            
            viewController.didReceiveResponse(response)
        }
        
        return viewController
    }
    
    static func prepare(_ viewController: UIViewController, identifier: String?, parameters: [String: Any]?, protectionSpace: ProtectionSpace?) {
        let identifier = UUID().uuidString
        
        viewController.restorationIdentifier = identifier
        viewController.restorationClass = StateRestoration.self
        
        let protectionSpaceClass: ProtectionSpace.Type? = {
            guard let protectionSpace = protectionSpace else { return nil }
            
            return type(of: protectionSpace)
        }()

        let parametersData: Data? = {
            guard let parameters = parameters else { return nil }
            return try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }()
        
        let storageItem = StorageItem(identifier: identifier, viewControllerClass: type(of: viewController), parameters: parametersData, protectionSpaceClass: protectionSpaceClass)
        
        store(storageItem)
    }
    
    
    private static func find(identifier: String) -> StorageItem? {
        guard let data = UserDefaults.standard.object(forKey: storageIdentifier(for: identifier)) as? Data else { return nil }
        
        return try? JSONDecoder().decode(StorageItem.self, from: data)
    }
    
    private static func store(_ storageItem: StorageItem) {
        let data = try? JSONEncoder().encode(storageItem)
        UserDefaults.standard.set(data, forKey: storageIdentifier(for: storageItem.identifier))
        UserDefaults.standard.synchronize()
    }
    
    private static func storageIdentifier(for identifier: String) -> String {
        return storageIdentifier + "." + identifier
    }
}
