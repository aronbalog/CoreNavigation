import UIKit
import PlaygroundSupport
import CoreNavigation

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
}

class OtherViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
    }
}

PlaygroundPage.current.liveView = MyViewController()

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

    Navigate.present { $0
        .to(OtherViewController())
        .embeddedInNavigationController()
    }
}
