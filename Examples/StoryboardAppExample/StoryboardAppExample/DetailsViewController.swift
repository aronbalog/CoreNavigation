import UIKit
import CoreNavigation

final class DetailsViewController: UIViewController, DataReceivable, Routable {
    typealias DataType = UIColor
    
    static func routePatterns() -> [String] {
        return ["some/:param1"]
    }
    
    required init(parameters: [String : Any]?) {
        super.init(nibName: nil, bundle: nil)

        self.title = parameters?["param1"] as? String
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    func didReceiveData(_ data: UIColor) {
        self.view.backgroundColor = data
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let backgroundColor = coder.decodeObject(forKey: "backgroundColor") as? UIColor {
            self.view.backgroundColor = backgroundColor
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(view.backgroundColor, forKey: "backgroundColor")
    }
}

