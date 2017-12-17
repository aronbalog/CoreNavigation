import UIKit

extension UINavigationController: ViewControllerEmbedding {
    
}

extension ViewControllerEmbedding where Self: UINavigationController {
    public init(with response: Response<UIViewController, UIViewController, UIViewController>) {
        if let viewController = response.toViewController {
            self.init(rootViewController: viewController)
        } else {
            self.init()
        }
    }
}
