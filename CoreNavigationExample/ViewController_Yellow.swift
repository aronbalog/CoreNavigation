import UIKit

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
            print("RESPONSE RECEIVED!", response.parameters!)
        }
    }
}
