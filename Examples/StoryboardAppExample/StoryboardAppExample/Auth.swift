
import CoreNavigation
import LocalAuthentication

class Auth: Protectable {
    static var isSignedIn = false
    
    let authContext = LAContext()
    
    func protect(with context: Protection.Context) throws {
        if Auth.isSignedIn {
            context.allow()
            return
        }
        
        var error: NSError?
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Log in to your account"
            
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if let error = error {
                    context.disallow(with: error)
                    return
                }
               
                guard success else {
                    context.disallow(with: Error.unknown)
                    return
                }
                
                Auth.isSignedIn = true
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    context.allow()
                })
            }
        }
        
        if let error = error {
            context.disallow(with: error)
        }
    }
}





extension Auth {
    enum Error: Swift.Error {
        case unknown
    }
}
