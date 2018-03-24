import UIKit

extension UIApplication {
    private static let runOnce: Void = {
        UIViewController.swizzleMethods
    }()
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
