import Foundation

protocol HistoryItem: class {
    var viewController: UIViewController? { get }
    var navigationType: NavigationType { get }
    func go(_ direction: HistoryDirection, animated: Bool, completion: (() -> Void)?)
}
