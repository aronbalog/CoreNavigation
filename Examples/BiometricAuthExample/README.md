# BiometricAuthExample

This is an example project which demonstrates the usage of [`CoreNavigation`]'s navigation protection.

## Installation

Clone [`CoreNavigation`] repo and:

```bash
$ cd Examples/BiometricAuthExample
$ pod install
```

## Use case

>
- App has three main view controllers:
    - `Root`
    - `My profile` - available only to authenticated users
    - `Sign in`
- When authenticated user tries to `My profile`, it should be presented.
- When public user tries to open `My profile`, app should activate biometric authentication.
- If biometric authentication is unavailable, app should present `Sign in` view controller.
- On successful authentication, `My profile` should present automatically.

## Demo

<p align="center">
  <img width="300" src="Documentation/Assets/BiometricAuthentication.gif">
</p>

<p align="center">
  <img width="300" src="Documentation/Assets/CredentialsAuthentication.gif">
</p>


[`CoreNavigation`]: https://github.com/aronbalog/CoreNavigation

## Code

Navigation:

```swift
import CoreNavigation

let fallback = CredentialsAuthentication()
let protection = BiometricAuthentication(fallback: fallback)

Navigate.present { $0
    .to(MyProfile())
    .protect(with: protection)
    .embeddedInNavigationController()
}
```

`BiometricAuthentication` implementation:

> [`LocalAuthentication Apple Documentation](https://developer.apple.com/documentation/localauthentication/)

```swift
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
```

`CredentialsAuthentication ` implementation (fallback):

```swift
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
```