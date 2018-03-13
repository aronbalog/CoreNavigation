import UIKit

public enum Destination {
    case viewController(UIViewController)
    case viewControllerBlock((@escaping (UIViewController) -> Void) -> Void)
    case routePath(String)
    case unknown
}
