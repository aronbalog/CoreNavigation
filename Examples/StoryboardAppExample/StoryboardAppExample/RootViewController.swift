import UIKit
import CoreNavigation
import LocalAuthentication

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTap(_ sender: Any) {

        Present { $0
            .to(DetailsViewController.self)
            .passDataToViewController(.green)
            .embed(inside: Embedding.EmbeddingType.navigationController(UINavigationController.self, { () -> Embedding.EmbeddingType in
                .none
            }))
            .animated(false)
        }
        ==> Push(matchable: "some/other-param", animated: false)
        ==> Dismiss()
        /*
        PerformSegue { $0
            .segue(identifier: "Details")
            .prepare({ (segue, sender) in
                // prepare for segue
            })
            .passDataToViewController("Hello")
//            .protect(with: Auth())
            .stateRestorable(with: "ID")
        }
         
            ==>
        Present { $0
            .to(DetailsViewController.self)
            .embed(inside: .navigationController(UINavigationController.self, {
                .none
            }))
            .animated(false)
            .cache(cacheIdentifier: "cache-id", cachingType: .timeInterval(10))
        } ==>
        Push(viewController: DetailsViewController(), animated: false, completion: { result in
            // did complete
        }) ==>
        Push(matchable: "some/route", animated: false) ==>
        "some/other-route".push() ==>
        Push(destination: DetailsDestination())
 */
    }
}

