import UIKit
import PlaygroundSupport

import CoreNavigation

class MyVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
}

PlaygroundPage.current.liveView = UINavigationController(rootViewController: UIViewController())

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    Navigation.present { $0
        .to(UINavigationController(rootViewController: MyVC()))
        .animated(true)
        .completion {
            print("Completed!")
        }
        .completion {
            print("Completed 2!")
        }
    }.present { $0
        .to(UINavigationController(rootViewController: MyVC()))
        .animated(true)
        .completion {
            print("Completed!")
        }
        .completion {
            print("Completed 2!")
        }
    }
    
    
}

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    Navigation.history.back(animated: true, steps: 2)
}
