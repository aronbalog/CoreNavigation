import Foundation
import CoreNavigation
import LocalAuthentication

class BiometricAuthentication: ProtectionSpace {
    let context = LAContext()
    let myLocalizedReasonString = "App needs authentication"
    
    let fallback: ProtectionSpace
    
    init(fallback: ProtectionSpace) {
        self.fallback = fallback
    }
    
    func protect(_ handler: ProtectionHandler) {
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { [weak self] success, evaluateError in
                    if success {
                        Authentication.shared.isUserSignedIn = true
                        handler.unprotect()
                    } else {
                        Authentication.shared.isUserSignedIn = false
                        
                        // fallback
                        self?.fallback.protect(handler)
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                
                // fallback
                fallback.protect(handler)
            }
        } else {
            // fallback
            fallback.protect(handler)
        }
    }
    
    func shouldProtect() -> Bool {
        return Authentication.shared.isUserSignedIn == false
    }
}
