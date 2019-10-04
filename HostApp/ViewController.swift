import UIKit
import CoreNavigation

final class ViewController: UIViewController, DataReceivable, Routable {
    init(parameters: [String : Any]?) {
        print("Init 1 with params", parameters)
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
        ["some/:id"]
    }
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(didTap), for: UIControl.Event.touchUpInside)
        
        button.setTitle("Navigate", for: UIControl.State.normal)
        button.backgroundColor = .gray
        return button
    }()
    
    func didReceiveData(_ data: UIColor) {
        
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
    }
    
    @objc func didTap() {
//        Present { $0
//            .to(ViewController2.self, from: self)
//            .onReturnedData { data, viewController in
//                self.view.backgroundColor = data
//            }
//            .passDataToViewController(UIColor.random)
//            .isModalInPresentation(true)
//            .embed(inside:
//                .navigationController(UINavigationController.self, { () -> Embedding.EmbeddingType in
//                    .none
//                })
//            )
//        }
        
        
        
        
        
        "some/1".present { $0
            .animated(false)
            .isModalInPresentation(true)
            .embed(inside:
                .navigationController(UINavigationController.self, { () -> Embedding.EmbeddingType in
                    .none
                })
            )
        }
        
        
        
        
        
        
        
//        "some/1".present { $0
//            .animated(false)
//            .embed(inside:
//                .navigationController(UINavigationController.self, { () -> Embedding.EmbeddingType in
//                    .none
//                })
//            )
//        }
//        ==> "some/2".push(animated: false)
//        ==> "some/2".push(animated: false)
//        ==> "some/3".push(animated: false)
//        ==> "some/4".push(animated: false)
//        ==> "some/5".push(animated: false)
    }
}
