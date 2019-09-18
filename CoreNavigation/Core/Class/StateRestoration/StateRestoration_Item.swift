extension StateRestoration {
    @objc(StateRestorationItem)
    class Item: NSObject, NSCoding {
        let identifier: String
        let viewControllerClass: UIViewController.Type
        let viewControllerData: Any?
        
        init(identifier: String, viewControllerClass: UIViewController.Type, viewControllerData: Any?) {
            self.identifier = identifier
            self.viewControllerClass = viewControllerClass
            self.viewControllerData = viewControllerData
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(identifier, forKey: "identifier")
            aCoder.encode(NSStringFromClass(viewControllerClass), forKey: "viewControllerClass")
            if let viewControllerData = viewControllerData {
                aCoder.encode(viewControllerData, forKey: "viewControllerData")
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.identifier = aDecoder.decodeObject(forKey: "identifier") as! String
            
            let viewControllerClassString = aDecoder.decodeObject(forKey: "viewControllerClass") as! String
            self.viewControllerClass = NSClassFromString(viewControllerClassString) as! UIViewController.Type
            self.viewControllerData = aDecoder.decodeObject(forKey: "viewControllerData")
        }
    }
}
