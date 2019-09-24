import SafariServices

class StateRestoration {
    static func prepare(
        viewController: UIViewController,
        identifier: String,
        viewControllerData: Any?,
        expirationDate: Date
    ) {
        viewController.restorationIdentifier = identifier
        
        if #available(iOS 9.0, *) {
            if !(viewController is SFSafariViewController) {
                viewController.restorationClass = StateRestoration.self
            }
        } else {
            viewController.restorationClass = StateRestoration.self
        }
        
        let item = Item(
            identifier: identifier,
            viewControllerClass: type(of: viewController),
            viewControllerData: viewControllerData,
            expirationDate: expirationDate
            )
        
        store(item)
    }
    
    private static func store(_ item: Item) {
        let data = NSKeyedArchiver.archivedData(withRootObject: item)
        UserDefaults.standard.set(data, forKey: storageIdentifier(for: item.identifier))
        
        UserDefaults.standard.synchronize()
    }
    
    private static func storageIdentifier(for identifier: String) -> String {
        "CoreNavigation.StateRestoration.\(identifier)"
    }
}

extension StateRestoration: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        guard let identifier = identifierComponents.last else { return nil }
        guard let item = find(identifier: identifier) else { return nil }
        let viewController: UIViewController = {
            item.viewControllerClass.init(coder: coder) ?? item.viewControllerClass.init()
        }()
        
        if let dataReceivable = viewController as? AnyDataReceivable {
            dataReceivable.didReceiveAnyData(item.viewControllerData)
        }
        
        prepare(
            viewController: viewController,
            identifier: item.identifier,
            viewControllerData: item.viewControllerData,
            expirationDate: item.expirationDate)
        
        return viewController
    }
    
    private static func find(identifier: String) -> Item? {
        let key = storageIdentifier(for: identifier)
        guard
            let data = UserDefaults.standard.object(forKey: key) as? Data,
            let item = NSKeyedUnarchiver.unarchiveObject(with: data) as? Item
            else { return nil }
        
        if Date() > item.expirationDate {
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()
            
            return nil
        }
        
        return item
    }
}
