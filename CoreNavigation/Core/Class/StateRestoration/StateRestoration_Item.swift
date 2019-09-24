extension StateRestoration {
    @objc(StateRestorationItem)
    class Item: NSObject, NSCoding {
        let identifier: String
        let viewControllerClass: UIViewController.Type
        let viewControllerData: Any?
        let expirationDate: Date
        
        init(identifier: String,
             viewControllerClass: UIViewController.Type,
             viewControllerData: Any?,
             expirationDate: Date) {
            self.identifier = identifier
            self.viewControllerClass = viewControllerClass
            self.viewControllerData = viewControllerData
            self.expirationDate = expirationDate
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(identifier, forKey: "identifier")
            aCoder.encode(NSStringFromClass(viewControllerClass), forKey: "viewControllerClass")
            if let viewControllerData = viewControllerData {
                aCoder.encode(viewControllerData, forKey: "viewControllerData")
            }
            aCoder.encode(expirationDate, forKey: "expirationDate")
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard
                let identifier = aDecoder.decodeObject(forKey: "identifier") as? String,
                let viewControllerClassString = aDecoder.decodeObject(forKey: "viewControllerClass") as? String,
                let viewControllerClass = NSClassFromString(viewControllerClassString) as? UIViewController.Type,
                let expirationDate = aDecoder.decodeObject(forKey: "expirationDate") as? Date else {
                    return nil
            }
            
            let viewControllerData = aDecoder.decodeObject(forKey: "viewControllerData")
            
            self.identifier = identifier
            self.viewControllerClass = viewControllerClass
            self.viewControllerData = viewControllerData
            self.expirationDate = expirationDate
        }
    }
}
