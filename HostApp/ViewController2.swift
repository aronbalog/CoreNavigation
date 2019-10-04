import UIKit
import CoreNavigation

final class ViewController2: UIViewController, DataReceivable, Routable {
    init(parameters: [String : Any]?) {
        print("Init 2 with params", parameters)
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    typealias DataType = UIColor
    
    static func routePatterns() -> [String] {
        ["other/:id"]
    }
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(didTap), for: UIControl.Event.touchUpInside)
        
        button.setTitle("Back", for: UIControl.State.normal)
        button.backgroundColor = .gray
        return button
    }()
    
    lazy var closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(close))
    
    func didReceiveData(_ data: UIColor) {
        print("Data 2!")
        view.backgroundColor = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        var frame = CGRect.zero
        frame.size.width = 200
        frame.size.height = 200
        
        button.frame = frame
        button.center = view.center
        view.addSubview(button)
        navigationItem.setRightBarButton(closeBarButtonItem, animated: true)
    }
    
    @objc func close() {
        didTap()
    }
    
    @objc func didTap() {
//        let color = UIColor.random
        
        Close(.automatic) { $0
            .visibleViewController()
            .passDataToViewController(self.view.backgroundColor!)
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
