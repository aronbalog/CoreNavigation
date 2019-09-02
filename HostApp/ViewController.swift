import UIKit
import CoreNavigation

class ViewController2: UIViewController, DataReceivable {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("Init!")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(didTap)), animated: false)
    }
        
    @objc func didTap() {
        Dismiss()
    }
    
    func didReceiveData(_ data: String) {
        print("data in VC \(data)")
    }
}

class ViewController: UIViewController {
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(didTap), for: UIControl.Event.touchUpInside)
        button.setTitle("Navigate", for: UIControl.State.normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.frame = view.bounds
        view.addSubview(button)
    }
    
    @objc func didTap() {

    }


}
