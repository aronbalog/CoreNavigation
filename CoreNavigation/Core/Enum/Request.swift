import UIKit

enum Request<ViewControllerType: UIViewController> {
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    case viewController(UIViewController)
    case viewControllerBlock((@escaping (Result<ViewControllerType>) -> Void) -> Void)
    case viewControllerClassBlock((@escaping (Result<ViewControllerType.Type>) -> Void) -> Void)
}
