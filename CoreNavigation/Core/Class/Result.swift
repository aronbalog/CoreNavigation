import Foundation

/// Object containing destination and its data. It is returned in navigation success observation.
public class Result<T1: UIViewController, T2>: Resultable {
    public typealias ToViewController = T1
    public typealias DataType = T2

    /// Destination view controller instance.
    public let toViewController: T1

    /// Passed data during navigation.
    public let data: T2?

    /// :nodoc:
    public required init(toViewController: T1, data: T2?) {
        self.toViewController = toViewController
        self.data = data
    }
}
