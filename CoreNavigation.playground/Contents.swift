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
    Navigation.push { $0
        .to(MyVC())
        .animated(true)
        .completion {
            print("Completed!")
        }
        .completion {
            print("Completed 2!")
        }
    }
}

