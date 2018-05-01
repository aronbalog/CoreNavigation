import Foundation
import CoreNavigation

struct MyProfile: Destination {
    class ViewControllerType: UIViewController {
        lazy var closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
        lazy var label = UILabel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            navigationItem.setRightBarButton(closeBarButtonItem, animated: false)
            
            view.addSubview(label)
            
            label.text = "Hello!"
            label.font = .preferredFont(forTextStyle: .largeTitle)
            label.sizeToFit()
            label.center = view.center
        }
        
        @objc func close() {
            dismiss(animated: true, completion: nil)
        }
    }
}
