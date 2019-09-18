public protocol AnyDataReceivable {
    func didReceiveAnyData(_ data: Any?)
}

extension AnyDataReceivable where Self: DataReceivable {
    public func didReceiveAnyData(_ data: Any?) {
        guard let data = data as? Self.DataType else { return }

        didReceiveData(data)
    }
}
