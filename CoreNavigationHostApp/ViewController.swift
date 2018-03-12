import UIKit
import CoreNavigation

class MyVC: UIViewController {
    lazy var close = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(closeVC))
    
    @objc func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        navigationItem.setRightBarButton(close, animated: true)
    }
}


class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Navigation
                .present { $0
                    .to(MyVC())
                    .embedInNavigationController()
                    .animated(false)
                }.present { $0
                    .to(MyVC())
                    .embedInNavigationController()
                    .animated(false)
                }.push { $0
                    .to(MyVC())
                    .animated(false)
                }.push { $0
                    .to(MyVC())
                    .animated(false)
                }.push { $0
                    .to(MyVC())
                    .animated(false)
                }.present { $0
                    .to(MyVC())
                    .embedInNavigationController()
                    .animated(false)
                }.push { $0
                    .to(MyVC())
                    .animated(false)
                }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Navigation.history.back(animated: true, steps: 6)
            }
        }
    }
}
