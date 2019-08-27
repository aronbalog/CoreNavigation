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
    let custom = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
    
    func didReceiveData(_ data: String) {
        print("data in view controller \(data)")
    }
}

class ViewController3: UIViewController, DataReceivable {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    }
    func didReceiveData(_ data: String) {
        print("data in view controller 3 \(data)")
    }
}

enum MyError: Error {
    case unknown
}

class MyProtection: Protectable, DataReceivable {
    typealias DataType = String
    
    func protect(handler: ProtectionHandler) throws {
        handler.allow()
    }
    
    func didReceiveData(_ data: String) {
        print("data in protection \(data)")
    }
}

class MyEmbeddable: Embeddable, DataReceivable {
    func embed(with context: Embedding.Context) throws {
        context.complete(viewController: ViewController3())
    }
    typealias DataType = String
    
    func didReceiveData(_ data: String) {
        print("data in embeddable \(data)")
    }
}

class ViewController: UIViewController {
    var custom = "2"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Present { return $0
            .to(Other())
            .from(self)
            .embed(with: .tabBarController(.navigationController(.embeddable(MyEmbeddable(), nil))))
            .passData("Hello!")
            .onSuccess({ (result) in
                print("Success", result.fromViewController?.custom, result.toViewController.custom)
            })
            .onFailure({ (error) in
                print("Failure", error)
            })
        }
    }


}

