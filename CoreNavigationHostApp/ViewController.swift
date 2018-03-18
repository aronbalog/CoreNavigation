import UIKit
import CoreNavigation

class ViewController: UIViewController {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            Navigation
            .present { $0
                .to("pattern/drek-something/balog")
                .pass(["kurac":"od ovce"])
                .animated(false)
                .embedInNavigationController()
            }
//            .push { $0
//                .to(MyVC())
//                .animated(false)
//            }
//            .push { $0
//                .to(MyVC())
//                .animated(true)
//            }
//            .present { $0
//                .to(OtherVC())
//                .embedInNavigationController()
//                .animated(true)
//            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
                Navigation.history.back(steps: 1)
            })
        }
    }
}
