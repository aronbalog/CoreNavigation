import Foundation

public protocol DataReceivable where Self: UIViewController {
    associatedtype DataType
    
    func didReceiveData(_ data: DataType)
}
