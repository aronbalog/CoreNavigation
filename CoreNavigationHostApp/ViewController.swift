import UIKit
import CoreNavigation

class MyVC: UIViewController {
    lazy var close = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(closeVC))
    
    @objc func closeVC() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        navigationItem.setRightBarButton(close, animated: true)
    }
}

class OtherVC: MyVC, DataReceivable {
    func didReceiveData(_ data: String) {
        print("Data!", data)
    }
    
    typealias ParametersType = String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
    }
}

struct MyRoute: Route {
    typealias Destination = OtherVC
    
    init() {}
    
    func route(handler: RouteHandler<MyRoute>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            handler.complete(data: "hello")
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Navigation
            .present { $0
                .to(MyRoute())
                .animated(false)
                .pass("Hello!")
                .embedInNavigationController()
                .completion({
                    print("Completed A!")
                })
                .on(.completion({
                    print("Completed B!")
                }))
                .event.completion {
                    print("Completed C!")
                }
                .event.passData({ (data) in
                    print("Passed A:", data)
                })
                .on(.passData({ (data) in
                    print("Passed B:", data)
                }))
            }
            .present { $0
                .to(MyVC())
                .embedInNavigationController()
                .animated(false)
            }
            .present { $0
                .to(MyRoute())
                .animated(false)
                .pass("Hello 2!")
                .embedInNavigationController()
            }
            .present { $0
                .to(MyVC())
                .embedInNavigationController()
                .animated(false)
            }
        }
                    /*
         
         
                .push { $0
                    .to(MyVC())
                    .animated(true)
                }
                .push { $0
                    .to(MyVC())
                    .animated(true)
                }
                .push { $0
                    .to(OtherVC())
                    .animated(true)
                    .pass(1)
                }
                .present { $0
                    .to(OtherVC())
                    .embedInNavigationController()
                    .animated(true)
                    .pass(2)
                }
                .push { $0
                    .to(MyRoute())
                    .animated(true)
                    .pass("Hello 2!")
                    .completion({
                        print("Completed!")
                    })
                     */
    }
}
