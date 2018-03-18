import UIKit
import CoreNavigation

class ViewController: UIViewController {
    lazy var navigateBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Navigate", style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigate))
    
    @objc func navigate() {
        Navigation
            .present { $0
                .to("pattern/aron-123-something/balog")
//                .pass(["kurac":"od ovce"])
                .stateRestorable()
                .embeddedInNavigationController()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        restorationIdentifier = "VC"
        
        navigationItem.setLeftBarButton(navigateBarButtonItem, animated: false)
    }
}
