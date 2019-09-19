import UIKit
import CoreNavigation

class ViewController2: UIViewController, DataReceivable {
    typealias DataType = String
    
    func didReceiveData(_ data: String) {
        print("DATA!!!", data)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        view.backgroundColor = coder.decodeObject(forKey: "view.backgroundColor") as? UIColor
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(view.backgroundColor, forKey: "view.backgroundColor")
    }
}
