import UIKit
import CoreNavigation

class ViewController2: UIViewController, DataReceivable {
    typealias DataType = String
    
    func didReceiveData(_ data: String) {
        print("DATA!!!", data)
    }
}
