public protocol DataReceivable: AnyDataReceivable {
    associatedtype DataType
    
    func didReceiveData(_ data: DataType)
}


