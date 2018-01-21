import UIKit

extension ViewController {
    class Purple: UIViewController, ResponseAware {
        lazy var button: UIButton = {
            let button = UIButton(type: UIButtonType.system)
            button.addTarget(self, action: #selector(didTouchUpInside(_:)), for: UIControlEvents.touchUpInside)
            button.setTitle("Open Green", for: UIControlState.normal)
            return button
        }()
        
        lazy var closeButton: UIButton = {
            let button = UIButton(type: UIButtonType.system)
            button.addTarget(self, action: #selector(close), for: UIControlEvents.touchUpInside)
            button.setTitle("Close", for: UIControlState.normal)
            return button
        }()
        
        @objc func didTouchUpInside(_ button: UIButton) {
            Navigation.present { $0
                .to(ViewController.Green.self)
                .withStateRestoration()
                //                .protect(with: Auth())
            }
        }
        
        @objc func close() {
            dismiss(animated: true, completion: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .purple
            
            button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            button.center = view.center
            
            closeButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            
//            view.addSubview(button)
            view.addSubview(closeButton)
        }
        
        public func didReceiveResponse(_ response: Response<UIViewController, UIViewController, UIViewController>) {
        }
        
        
    }
}


