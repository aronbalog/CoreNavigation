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
    let id: String!
    
    init(parameters: [String : Any]?) {
        self.id = parameters?["id"] as? String
    }
    
    typealias ViewControllerType = ViewController3
    
    static func routePatterns() -> [String] {
        return ["some/:id"]
    }
    
    func resolve(with resolver: Resolver<VC3Dest>) {
        resolver.complete(viewController: ViewController3.init(id: id))
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
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = id
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        "some/1".present { $0
            .animated(false)
            .embed(inside:
                .navigationController(UINavigationController.self, { () -> Embedding.EmbeddingType in
                    .pageViewController(UIPageViewController.self, {
                        .none
                    })
                })
            )
        }
//        ==> "some/1".push(animated: false)
//        ==> "some/2".push(animated: false)
//        ==> "some/3".push(animated: false)
//        ==> "some/4".push(animated: false)
//        ==> "some/5".push(animated: false)
    }
}
