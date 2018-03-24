import Foundation

public protocol DataReceivingViewController: DataReceiving where Self: UIViewController {
    associatedtype DataType
    
    func didReceiveData(_ data: DataType)
}

extension DataReceivingViewController {
    public func didReceiveAbstractData(_ data: Any?) {
        guard let data = data as? DataType else { return }
        
        self.didReceiveData(data)
    }
}
