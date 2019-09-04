import UIKit
import CoreNavigation

struct VC2Dest: Destination {
    typealias ViewControllerType = ViewController2
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
        title = "Title"
        view.backgroundColor = .white
        navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(didTap)), animated: false)
    }
        
    @objc func didTap() {
        Dismiss()
    }
    
    func didReceiveData(_ data: String) {
        print("data in VC \(data)")
    }
}

class ViewController: UIViewController {
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(didTap), for: UIControl.Event.touchUpInside)
        button.setTitle("Navigate", for: UIControl.State.normal)
        button.backgroundColor = .gray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame = CGRect.zero
        frame.size.width = 200
        frame.size.height = 200
        
        button.frame = frame
        button.center = view.center
        view.addSubview(button)
    }
    
    @objc func didTap() {
        Present { $0
            .to(ViewController2(), from: self)
            .embed(inside:
                .tabBarController(UITabBarController.self, {
                    .navigationController(UINavigationController.self, {
                        .none
                    })
                })
            )
        }
    }
}
//            .transition(with: 0.3, viewController_ViewController2)
