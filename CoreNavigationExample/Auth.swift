import Foundation
import UIKit


class Auth: ProtectionSpace {
    var loggedIn: Bool = false

    func shouldProtect(unprotect: @escaping () -> Void, failure: @escaping (Error) -> Void) -> Bool {
        if loggedIn {
            return false
        }
        
        var vc: UIViewController?
        
        Navigation.present { (present) in
            present
                .to(ViewController.Green.self)
                .onSuccess({ (response) in
                    vc = response.toViewController
                })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loggedIn = true
            
            vc?.dismiss(animated: true, completion: {
                unprotect()
            })
        }
        
        return !loggedIn
    }
    
    init(loggedIn: Bool = false) {
        self.loggedIn = loggedIn
    }
}
