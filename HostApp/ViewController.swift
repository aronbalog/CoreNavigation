import UIKit
import CoreNavigation

struct VC2Dest: Destination, Protectable {
    typealias ViewControllerType = ViewController2
    
    func protect(with context: Protection.Context) throws {
        enum MyError: Error {
            case unknown
        }
        context.allow()//.disallow(with: MyError.unknown)
    }
}

struct VC3Dest: Destination, Routable {
    init(parameters: [String : Any]?) {
        
    }
    
    typealias ViewControllerType = ViewController3
    
    static func routePatterns() -> [String] {
        return ["some"]
    }
}

class ViewController2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Title"
        view.backgroundColor = .white
        navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(didTap)), animated: false)
    }
        
    @objc func didTap() {
        Dismiss()
    }
}

class ViewController3: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Title"
        view.backgroundColor = .orange
        navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(didTap)), animated: false)
    }
    
    @objc func didTap() {
        Dismiss()
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
        
        Register(VC3Dest.self)
        
        view.backgroundColor = .orange
        
        var frame = CGRect.zero
        frame.size.width = 200
        frame.size.height = 200
        
        button.frame = frame
        button.center = view.center
        view.addSubview(button)
        navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(close)), animated: false)
    }
    
    @objc func close() {
        Dismiss()
    }
    
    @objc func didTap() {
        Present { $0
            .to(VC2Dest())
            .embed(inside:
                .navigationController(UINavigationController.self, {
                    .none
                })
            )
            .animated(true)
        }
//        VC2Dest().present(animated: false)
        ==>
        "some".push(animated: true)
    }
}
