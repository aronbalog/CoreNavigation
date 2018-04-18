import UIKit
import PlaygroundSupport

import CoreNavigation

struct MyRoute: Destination, Routable {
    typealias ViewControllerType = MyVC
    
    static var patterns: [String] = [
        "my-route"
    ]
}

class MyVC: UIViewController, DataReceivable {
    typealias DataType = String
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
    
    func didReceiveData(_ data: String) {
        
    }
}

Navigation.router.register(MyRoute.self)

PlaygroundPage.current.liveView = UINavigationController(rootViewController: UIViewController())

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    Navigation.present { $0
        .to(UINavigationController(rootViewController: MyVC()))
        .animated(false)
        .completion {
            print("Completed!")
        }
    }.present { $0
        .to("my-route")
        .embeddedInNavigationController()
        .animated(true)
        .completion {
            print("Completed 2!")
        }
        .passData("Data is passed!")
        .onFailure({ (error) in
            print("Got error!", error)
        })
        .onSuccess({ (result) in
            print("Passed data: ", result.data)
        })
    }.present { $0
        .to(MyVC.self)
        .embeddedInNavigationController()
        .animated(true)
        .onSuccess({ (result) in
            
        })
        .completion {
            print("Completed 3!")
        }
    }
    
    
}

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    Navigation.history.back(steps: 2, animated: true)
}
