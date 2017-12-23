import UIKit

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Navigation.present { $0
            .to(ViewController.Yellow())
            .embed(in: UINavigationController.self)
            .pass(parameters: [
                "firstName": "John",
                "lastName": "Doe"
                ])
        }
    }
}
