import UIKit
import CoreRoute

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, StateRestorationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        registerRoutes()

        let rootViewController = ViewController()
        window?.rootViewController = rootViewController
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func registerRoutes() {
        Navigation.router.register(routeType: Destination.Orange.self)
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, stateRestorationBehaviorForContext context: StateRestorationContext) -> StateRestorationBehavior {
        return .protect(protectionSpace: Auth(loggedIn: true))
    }
    
    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        return nil
    }
}

