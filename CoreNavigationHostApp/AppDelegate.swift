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
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //            self.view.backgroundColor = .green
        //        }
    }
}

struct MyRoute: Route, URLAccessibleRoute {
    static var pattern: String = "pattern/:firstName(.*)-something/:lastName(.*)"
    
    typealias Destination = OtherVC
    
    init() {}
    
    static func route(handler: RouteHandler<MyRoute>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            handler.complete(data: handler.parameters)
        }
    }
}

class MyLifetime: Lifetime {
    func cacheIdentifier() -> String {
        return "my"
    }
    
    func die(_ kill: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            kill()
        }
    }
}

//class MyProtectionSpace: ProtectionSpace {
//    func shouldProtect() -> Bool {
//        return !MyProtectionSpace.isSignedIn
//    }
//    
//    static var isSignedIn = false
//    
//    func protect(_ handler: ProtectionHandler) {
//        let viewController = UIViewController()
//        
//        Navigation.present { $0
//            .to(URL(string: "")!)
//            .unsafely()
//            .event.viewController(ViewControllerEvent<UIViewController>.viewDidLoad({ (viewController) in
//                viewController.view.backgroundColor = .yellow
//            }))
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            MyProtectionSpace.isSignedIn = true
//            
//            viewController.dismiss(animated: true, completion: {
//                handler.unprotect()
//            })
//        }
//    }
//}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, StateRestorationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Navigation.router.registerRoute(MyRoute.self)

        let rootViewController = UINavigationController(rootViewController: ViewController())
        rootViewController.restorationIdentifier = "root"
        
        window?.restorationIdentifier = "MainWindow"
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
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

