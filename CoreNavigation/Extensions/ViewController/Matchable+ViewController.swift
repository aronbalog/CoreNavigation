import Foundation

extension Matchable {
    func viewController<T: UIViewController>(_ viewControllerBlock: @escaping (T) -> Void) {
        UIViewController.route(to: self, viewControllerBlock)
    }
}
