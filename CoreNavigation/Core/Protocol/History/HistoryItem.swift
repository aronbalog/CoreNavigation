import Foundation

public protocol HistoryItem {
    var viewController: UIViewController { get }
    var navigationType: NavigationType { get }
    func go(_ direction: HistoryDirection, animated: Bool, completion: (() -> Void)?)
}
