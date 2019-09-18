import UIKit
import CoreNavigation

class ViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func navigate(_ sender: Any) {
        PerformSegue { $0
            .segue(identifier: "SegueId")
            .protect({ (context) in
                enum MyError: Error {
                    case unknown
                }
//                context.disallow(with: MyError.unknown)
                context.allow()
            })
            .catch({ (error) in
                print("Error! 😎")
            })
        }
    }
    
}

