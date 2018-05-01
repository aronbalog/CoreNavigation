import Foundation

class Authentication {
    enum Error: Swift.Error {
        case wrongCredentials
    }
    
    static let shared = Authentication()
    
    var isUserSignedIn = false {
        didSet {
            if isUserSignedIn == true {
                signInBlocks.forEach { $0() }
            } else {
                signOutBlocks.forEach { $0() }
            }
        }
    }
    
    var signInBlocks: [() -> Void] = []
    var signOutBlocks: [() -> Void] = []
    
    func userDidSignIn(_ completion: @escaping () -> Void) {
        signInBlocks.append(completion)
    }
    
    func userDidSignOut(_ completion: @escaping () -> Void) {
        signOutBlocks.append(completion)
    }
    
    func userDidChangeState(_ completion: @escaping (Bool) -> Void) {
        signOutBlocks.append({
            completion(self.isUserSignedIn)
        })
        signInBlocks.append({
            completion(self.isUserSignedIn)
        })
    }
    
    func signIn(username: String, password: String) throws {
        guard
            !username.isEmpty,
            !password.isEmpty
            else {
                throw Error.wrongCredentials
        }
        
        isUserSignedIn = true
    }
    
    func signOut() {
        isUserSignedIn = false
    }
}
