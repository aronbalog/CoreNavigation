import UIKit
import CoreNavigation

struct Other: Destination, DataReceivable {

    typealias ViewControllerType = ViewController2
    typealias DataType = String
    
    func didReceiveData(_ data: String) {
        print("data in destination \(data)")
    }
}

class ViewController2: UIViewController, DataReceivable {
    typealias DataType = String
    let custom = "2"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
    func didReceiveData(_ data: String) {
        print("Data in VC!", data)
    }
}

class ViewController3: UIViewController, DataReceivable {
    let custom = "3"
    typealias DataType = String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("Initing view controller")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func didReceiveData(_ data: String) {
        print("data in view controller 3 \(data)")
    }
}

enum MyError: Error {
    case unknown
    case protected
    case cannotEmbed
}

class MyProtection: Protectable {
    func protect(with context: Protection.Context) throws {
        print("Protecting 1")
        let viewController = ViewController2()
        
        Present({ $0
            .to(viewController)
            .onComplete({ (result) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    result.toViewController.dismiss(animated: true, completion: {
                        context.allow()
                    })
                }
            })
        })
    }
}

class MyProtection2: Protectable {
    func protect(with context: Protection.Context) throws {
        print("Protecting 2")
        let viewController = ViewController2()
        
        Present({ $0
            .to(viewController)
            .onComplete({ (result) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    result.toViewController.dismiss(animated: true, completion: {
                        context.allow()
                    })
                }
            })
        })
    }
}

class MyEmbeddable: Embeddable, DataReceivable {
    func embed(with context: Embedding.Context) throws {
        context.cancel(with: MyError.cannotEmbed)
    }
    typealias DataType = String
    
    func didReceiveData(_ data: String) {
        print("data in embeddable \(data)")
    }
}

class ViewController: UIViewController {
    var custom = "2"

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @objc func didTap() {
        Present { return $0
//            .to(ViewController3(), from: self)
//            .to(ViewController3(), from: self)
            .to(Other(), from: self)
            .embed(with: .tabBarController(nil))
            .passDataToViewController("Hello!!!")
            
//            .passData({ (context: DataPassing.Context<String>) in
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
//                    context.passData("Hello!")
//                })
//            })
            .protect(with: MyProtection())
            .onSuccess({ (result) in
                print("Success", result.fromViewController.custom, result.toViewController.custom)
            })
            .onComplete({ (result) in
                print("Complete", result.fromViewController.custom, result.toViewController.custom)
            })
            .onFailure({ (error) in
                print("Failure", error)
            })
        }
    }


}

