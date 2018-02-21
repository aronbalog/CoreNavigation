import Foundation
import CoreRoute

public extension Route {
    public var viewController: UIViewController? {
        return UIViewController.from(route: self)
    }
}

