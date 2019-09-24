import UIKit
import CoreNavigation

class ViewController: UIViewController {
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(didTap), for: UIControl.Event.touchUpInside)
        
        button.setTitle("Navigate", for: UIControl.State.normal)
        button.backgroundColor = .gray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        
        var frame = CGRect.zero
        frame.size.width = 200
        frame.size.height = 200
        
        button.frame = frame
        button.center = view.center
        view.addSubview(button)
        navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(close)), animated: false)
    }
    
    @objc func close() {
        Dismiss()
    }
    
    @objc func didTap() {
        "some/1".present { $0
            .animated(false)
            .embed(inside:
                .navigationController(UINavigationController.self, { () -> Embedding.EmbeddingType in
                    .none
                })
            )
            .transition(with: 3) { (context) in
                
            }
        }
        ==> "some/2".push(animated: false)
//        ==> "some/2".push(animated: false)
//        ==> "some/3".push(animated: false)
//        ==> "some/4".push(animated: false)
//        ==> "some/5".push(animated: false)
    }
}
