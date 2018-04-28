import Foundation

/// :nodoc:
public protocol Resultable {
    associatedtype ToViewController: UIViewController
    associatedtype DataType

    var toViewController: ToViewController { get }
    var data: DataType? { get }

    init(toViewController: ToViewController, data: DataType?)
}
