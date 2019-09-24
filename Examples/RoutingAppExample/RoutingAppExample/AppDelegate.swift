
import UIKit
import CoreNavigation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Register(ViewController.self)
        
        let viewController = try! "http://myapp.com".viewController()
        viewController.restorationIdentifier = "viewController"
        
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.rootViewController?.restorationIdentifier = "rootViewController"
        window?.restorationIdentifier = "rootWindow"
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
}




