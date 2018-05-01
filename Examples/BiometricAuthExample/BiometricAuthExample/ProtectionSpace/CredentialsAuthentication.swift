import Foundation
import CoreNavigation

class CredentialsAuthentication: ProtectionSpace {
    func protect(_ handler: ProtectionHandler) {
        Navigate.present { $0
            .to(SignIn())
            .embeddedInNavigationController()
            .onSuccess({ (result) in
                weak var viewController = result.toViewController
                Authentication.shared.userDidSignIn {
                    viewController?.dismiss(animated: true, completion: {
                        handler.unprotect()
                    })
                }
            })
        }
    }
    
    func shouldProtect() -> Bool {
        return Authentication.shared.isUserSignedIn == false
    }
}
