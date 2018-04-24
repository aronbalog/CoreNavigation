import UIKit
import CoreNavigation

class MyVC: UIViewController {
    lazy var close = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(closeVC))
    
    @objc func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        navigationItem.setRightBarButton(close, animated: true)
    }
}

class OtherVC: MyVC, DataReceivable {
    func didReceiveData(_ data: [String : Any]) {
        print("Data from VC! ", data)
    }
    
    typealias DataType = [String: Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
    }
}

struct MyRoute: Destination, Routable {
    typealias ViewControllerType = MyVC
    
    static var patterns = [
        "pattern/:firstName(.*)-something/:lastName(.*)",
        ":firstName(.*)/:lastName(.*)"
    ]
}

class MyLifetime: Lifetime {
    func die(_ kill: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            kill()
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, StateRestorationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.restorationIdentifier = "MainWindow"

//        MyRoute.register()
//        Navigation.router.register(MyRoute.self)
//
//        UIViewController.route(to: "pattern/aron-something/balog") { (viewController: MyVC) in
//            viewController.restorationIdentifier = "root"
//            self.window?.rootViewController = viewController
//            self.window?.makeKeyAndVisible()
//        }
//        
////        UIViewController.route(to: MyRoute()) { (viewController) in
////            viewController.restorationIdentifier = "root"
////            self.window?.rootViewController = viewController
////            self.window?.makeKeyAndVisible()
////        }
        
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

