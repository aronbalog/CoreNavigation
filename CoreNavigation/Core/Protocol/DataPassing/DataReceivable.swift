import Foundation

public protocol AbstractDataReceivable {
    func didReceiveAbstractData(_ data: Any?)
}

public protocol DataReceivable: AbstractDataReceivable where Self: UIViewController {
    associatedtype DataType
    
    func didReceiveData(_ data: DataType)
}

extension DataReceivable {
    public func didReceiveAbstractData(_ data: Any?) {
        guard let data = data as? DataType else { return }
        self.didReceiveData(data)
    }
}

