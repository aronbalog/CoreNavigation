import UIKit

class Auth: ProtectionSpace {
    var loggedIn: Bool = false
    
    func shouldProtect(unprotect: @escaping () -> Void, failure: @escaping (Error) -> Void) -> Bool {
        if loggedIn {
            return false
        }
        
        var vc: UIViewController?
        
        Navigation.present { (present) in
            present
                .to(ViewController.Green.self)
                .onSuccess({ (response) in
                    vc = response.toViewController
                })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            vc?.dismiss(animated: true, completion: {
                self.loggedIn = true
                unprotect()
            })
        }
        
        return !loggedIn
    }
}

extension ViewController {
    class Yellow: UIViewController, ResponseAware {
        lazy var button: UIButton = {
            let button = UIButton(type: UIButtonType.system)
            button.addTarget(self, action: #selector(didTouchUpInside(_:)), for: UIControlEvents.touchUpInside)
            button.setTitle("Open Orange", for: UIControlState.normal)
            return button
        }()
        
        @objc func didTouchUpInside(_ button: UIButton) {
            Navigation.push { $0
                .to("orange")
                .protect(with: Auth())
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .yellow
            
            button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            button.center = view.center
            
            view.addSubview(button)
        }
        
        public func didReceiveResponse(_ response: Response<UIViewController, UIViewController, UIViewController>) {
            
        }
    }
}
