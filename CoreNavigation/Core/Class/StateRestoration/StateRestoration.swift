class StateRestoration {
    static func prepare(
        viewController: UIViewController,
        identifier: String,
        restorationClass: UIViewControllerRestoration.Type,
        viewControllerData: Any?,
        expirationDate: Date
    ) {
        viewController.restorationIdentifier = identifier
        viewController.restorationClass = restorationClass
        
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
        return "CoreNavigation.StateRestoration.\(identifier)" 
    }
}

extension StateRestoration: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        guard let identifier = identifierComponents.last else { return nil }
        guard let item = find(identifier: identifier) else { return nil }
        guard let viewController = item.viewControllerClass.init(coder: coder) else { return nil }
        
        if let dataReceivable = viewController as? AnyDataReceivable {
            dataReceivable.didReceiveAnyData(item.viewControllerData)
        }
        
        prepare(viewController: viewController, identifier: item.identifier, restorationClass: self, viewControllerData: item.viewControllerData, expirationDate: item.expirationDate)
        
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
