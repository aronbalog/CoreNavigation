import UIKit

extension ViewController {
    class Yellow: UIViewController, ResponseAware {
        lazy var button: UIButton = {
            let button = UIButton(type: UIButtonType.system)
            button.addTarget(self, action: #selector(didTouchUpInside(_:)), for: UIControlEvents.touchUpInside)
            button.setTitle("Open Orange", for: UIControlState.normal)
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
                .to("orange")
                .pass(parameters: ["name": "matija"])
                .withStateRestoration()
                .protect(with: Auth())
                .embed(in: UINavigationController.self)
                
            }
        }
        
        @objc func close() {
            dismiss(animated: true, completion: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .yellow
            
            button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            button.center = view.center
            
            closeButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            
            view.addSubview(button)
            view.addSubview(closeButton)
        }
        
        public func didReceiveResponse(_ response: Response<UIViewController, UIViewController, UIViewController>) {
            
        }
        
        
    }
}
