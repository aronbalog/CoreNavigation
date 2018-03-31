import UIKit

enum Destination {
    case viewController(UIViewController)
    case viewControllerBlock((@escaping (UIViewController) -> Void) -> Void)
    case viewControllerClassBlock((@escaping (UIViewController.Type) -> Void) -> Void)
}
