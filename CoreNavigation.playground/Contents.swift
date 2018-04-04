import UIKit
import PlaygroundSupport

import CoreNavigation

class MyVC: UIViewController, DataReceivingViewController {
    typealias DataType = String
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
    
    func didReceiveData(_ data: String) {
        
    }
}

PlaygroundPage.current.liveView = UINavigationController(rootViewController: UIViewController())

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    Navigation.present { $0
        .to(UINavigationController(rootViewController: MyVC()))
        .animated(false)
        .completion {
            print("Completed!")
        }
    }.present { $0
        .to(MyVC.self)
        .embeddedInNavigationController()
        .animated(true)
        .completion {
            print("Completed 2!")
        }
    }.present { $0
        .to(MyVC.self)
        .embeddedInNavigationController()
        .animated(true)
        .completion {
            print("Completed 2!")
        }
        .onSuccess({ (viewController, data) in
            print("Viewcontroller: ", viewController)
            print("Data: ", data)
        })
    }
    
    
}

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    Navigation.history.back(steps: 2, animated: true)
}
