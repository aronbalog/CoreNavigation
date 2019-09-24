import UIKit
import CoreNavigation

final class ViewController: UIViewController, Routable {
    static func routePatterns() -> [String] {
        return [
            "http://myapp.com",
            "http://myapp.com/:parameter1(.*)",
            "http://myapp.com/:parameter1/:parameter2",
        ]
    }
    
    
    required init(parameters: [String : Any]?) {
        super.init(nibName: nil, bundle: nil)

        self.navigationItem.title = parameters?["parameter1"] as? String
        self.navigationItem.prompt = parameters?["parameter2"] as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var button1: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add1))
        
        return item
    }()
    
    lazy var button2: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add2))
        
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
        
        navigationItem.setRightBarButtonItems([
            button1,
            button2
            ], animated: false)
    }
    
    func didReceiveData(_ data: String) {
        print("Data:", data)
    }
    
    @objc func add1() {
        let number = Int.random(in: 0 ..< 10)

        "http://myapp.com/\(number)?parameter2=Push".push { $0
            .stateRestorable(with: "alo")
        }
    }
    
    @objc func add2() {
        let url = URL(string: "https://404.agency")!
        let destination = URLDestination(url: url)
        
        Present { $0
            .to(destination)
            .animated(false)
            .cache(cacheIdentifier: "404-page", cachingType: .timeInterval(3))
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(view.backgroundColor, forKey: "backgroundColor")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        view.backgroundColor = coder.decodeObject(forKey: "backgroundColor") as? UIColor
    }
}
