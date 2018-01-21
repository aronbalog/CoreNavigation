import UIKit

class ViewController: UIViewController, ResponseAware {
    lazy var button: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.addTarget(self, action: #selector(didTouchUpInside(_:)), for: UIControlEvents.touchUpInside)
        button.setTitle("Open Yellow", for: UIControlState.normal)
        return button
    }()
    
    @objc func didTouchUpInside(_ button: UIButton) {
        Navigation.present { $0
            .to(ViewController.Yellow.self)
            .from(self)
            //            .embed(in: UINavigationController.self)
            .withStateRestoration()
            .protect(with: Auth())
            .pass(parameters: [
                "firstName": "John",
                "lastName": "Doe"
                ])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restorationIdentifier = "root"
        view.backgroundColor = .white
        
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.center = view.center
        
        view.addSubview(button)
    }
    
    public func didReceiveResponse(_ response: Response<UIViewController, UIViewController, UIViewController>) {
        
    }
    
    
}
