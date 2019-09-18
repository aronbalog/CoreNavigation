import UIKit
import CoreNavigation

class ViewController1: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func navigate(_ sender: Any) {
//        PerformSegue(with: "SegueId")
        PerformSegue { $0
            .segue(identifier: "SegueId")
            .prepare({ (segue, sender) in
                
            })
            .stateRestorable(with: "RestId", expirationDate: Date().addingTimeInterval(10))
            .passDataToViewController("Data!")
            .onViewControllerEvents(.viewDidLoad({ (viewController) in
                print("Did load!")
            }))
        }
//        Push { $0
//            .to(ViewController2.self)
//            .passDataToViewController("Jebemti!")
//            .stateRestorable(with: "StateRestoration")
//        }
    }
    
    
}

