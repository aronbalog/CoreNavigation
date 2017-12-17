import Foundation

public protocol Eventable {
    func viewControllerEvents(_ viewControllerEventBlock: @escaping (ViewControllerEventable, UIViewController) -> Void) -> Self
}
