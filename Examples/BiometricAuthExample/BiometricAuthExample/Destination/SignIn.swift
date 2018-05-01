import Foundation
import CoreNavigation

struct SignIn: Destination {
    class ViewControllerType: UIViewController {
        lazy var closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
        
        lazy var usernameTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Username"
            textField.borderStyle = UITextBorderStyle.roundedRect
            return textField
        }()
        
        lazy var passwordTextField: UITextField = {
            let textField = UITextField()
            textField.isSecureTextEntry = true
            textField.placeholder = "Password"
            textField.borderStyle = UITextBorderStyle.roundedRect
            return textField
        }()
        
        lazy var signInButton: UIButton = {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
            button.setTitle("Sign in", for: UIControlState.normal)
            return button
        }()
        
        lazy var stackView: UIStackView = {
            let view = UIStackView(arrangedSubviews: [
                self.usernameTextField,
                self.passwordTextField,
                self.signInButton
                ])
            
            view.axis = .vertical
            view.distribution = .equalSpacing
            view.alignment = .center
            view.spacing = 30
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            navigationItem.setRightBarButton(closeBarButtonItem, animated: false)
            
            view.addSubview(stackView)
            
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        }
        
        @objc func close() {
            dismiss(animated: true, completion: nil)
        }
        
        @objc func didTouchUpInside(_ button: UIButton) {
            let username = usernameTextField.text ?? ""
            let password = usernameTextField.text ?? ""
            
            do {
                try Authentication.shared.signIn(username: username, password: password)
            } catch {
                let alertController = UIAlertController(title: "Error", message: "Wrong credentials", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
}
