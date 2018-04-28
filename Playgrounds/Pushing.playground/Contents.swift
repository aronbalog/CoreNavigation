import UIKit
import PlaygroundSupport
import CoreNavigation

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
}

class OtherViewController: UIViewController, DataReceivable {
    typealias DataType = String

    var data: String!

    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange

        view.addSubview(label)
    }

    func didReceiveData(_ data: String) {
        self.data = data
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        label.text = data
        label.sizeToFit()
        label.center = view.center
    }
}

PlaygroundPage.current.liveView = UINavigationController(rootViewController: MyViewController())

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

    Navigate.push { $0
        .to(OtherViewController())
        .withData("Hello!")
    }
}
