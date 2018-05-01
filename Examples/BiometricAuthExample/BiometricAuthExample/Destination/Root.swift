import Foundation
import CoreNavigation

struct Root: Destination {
    class ViewControllerType: UIViewController {
        lazy var label = UILabel()
        let signedInText = "You are authenticated!"
        let signedOutText = "You are public user!"
        
        lazy var myProfileBarButtonItem = UIBarButtonItem(
            title: "My profile",
            style: .plain,
            target: self,
            action: #selector(presentMyProfile))
        
        lazy var signOutBarButtonItem = UIBarButtonItem(
            title: "Sign out",
            style: .plain,
            target: self,
            action: #selector(signOut))
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            navigationItem.setLeftBarButton(signOutBarButtonItem, animated: false)
            navigationItem.setRightBarButton(myProfileBarButtonItem, animated: false)
            
            view.addSubview(label)
            label.font = .preferredFont(forTextStyle: .largeTitle)
            
            if Authentication.shared.isUserSignedIn {
                setSignedIn()
            } else {
                setSignedOut()
            }
            
            Authentication.shared.userDidChangeState { [weak self] isSignedIn in
                if isSignedIn {
                    self?.setSignedIn()
                } else {
                    self?.setSignedOut()
                }
            }
        }
        
        @objc func presentMyProfile() {
            Navigate.present { $0
                .to(MyProfile())
                .protect(with: BiometricAuthentication(fallback: CredentialsAuthentication()))
                .embeddedInNavigationController()
            }
        }
        
        @objc func signOut() {
            Authentication.shared.signOut()
        }
        
        func setSignedIn() {
            DispatchQueue.main.async {
                self.label.text = self.signedInText
                self.signOutBarButtonItem.isEnabled = true
                self.label.sizeToFit()
                self.label.center = self.view.center
            }
        }
        
        func setSignedOut() {
            DispatchQueue.main.async {
                self.label.text = self.signedOutText
                self.signOutBarButtonItem.isEnabled = false
                self.label.sizeToFit()
                self.label.center = self.view.center
            }
        }
    }
}
