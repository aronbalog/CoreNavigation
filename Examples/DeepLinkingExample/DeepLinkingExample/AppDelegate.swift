import UIKit
import CoreNavigation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        registerRoutes()
        
        let rootViewController = try! Color().viewController()
        
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        do {
            try userActivity.navigate()
        } catch {
            return false
        }
        
        return true
    }
    
    func registerRoutes() {
        Color.self <- [
            "https://demo7377577.mockable.io/color/:color([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})",
            "https://demo7377577.mockable.io/colour/:color([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})",
            "http://demo7377577.mockable.io/color/:color([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})",
            "http://demo7377577.mockable.io/colour/:color([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})"
        ]
    }
}
