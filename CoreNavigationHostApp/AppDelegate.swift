import UIKit
import CoreNavigation

struct Person {
    
}

class MyVC: UIViewController, DataReceivable {
    typealias DataType = Person
    
    func didReceiveData(_ data: Person) {
        
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, StateRestorationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.restorationIdentifier = "MainWindow"
        
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, stateRestorationBehaviorForContext context: StateRestorationContext) -> StateRestorationBehavior {
        return .allow
    }
}

