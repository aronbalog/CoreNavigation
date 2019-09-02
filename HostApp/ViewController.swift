import UIKit
import CoreNavigation

struct Other: Destination, DataReceivable, Routable {
    typealias ViewControllerType = ViewController2
    typealias DataType = String
    
    static func routePatterns() -> [String] {
        return [
            "hello/:personId"
        ]
    }
    
    init() {
        
    }
    
    init(parameters: [String : Any]?) {
        print("Parameters", parameters!)
    }
    
    func didReceiveData(_ data: String) {
        print("data in destination \(data)")
    }
}

class ViewController2: UIViewController, DataReceivable {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("Init!")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(didTap)), animated: false)
    }
        
    @objc func didTap() {
//        Dismiss(viewController: self)
        Dismiss()
    }
    
    func didReceiveData(_ data: String) {
        print("data in VC \(data)")
    }
}


//probat globalne metode za navigaciju tipa vc1 -> vc2 

class MyCacheable: Cacheable {
    func didCache(with context: Caching.Context) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            print("Invalidating cache!")
            context.invalidateCache()
        }
    }
}

class ViewController: UIViewController {
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(didTap), for: UIControl.Event.touchUpInside)
        button.setTitle("Navigate", for: UIControl.State.normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        button.frame = view.bounds
        view.addSubview(button)
    }
    
    @objc func didTap() {
//        self => Other()
        
        /*
        Present { $0
            .to("hello/1", from: self)
            .passData("Hello!")
            .onSuccess({ (result) in
                print("Success!")
            })
            .embed(with: .tabBarController(.navigationController(nil)))
        }
        */

        do {
            let vc = try "hello/1?data=1".viewController()
        } catch let error {
            print("Error: ", error)
        }
        
        
//        Other().present { $0
//            .embed(with: .tabBarController(.navigationController(nil)))
//        }
    }


}

