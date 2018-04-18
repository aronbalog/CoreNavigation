import Foundation

/// Describes view controller which can receive data.
public protocol DataReceivable: AbstractDataReceivable where Self: UIViewController {
    associatedtype DataType
    
    /// Called by module when data passing occurs.
    ///
    /// - Parameter data: Data passed on navigation.
    func didReceiveData(_ data: DataType)
}

// MARK: - DataReceiving default implementation
extension DataReceivable {
    /// Called by module when data passing occurs.
    ///
    /// - Parameter data: Data passed on navigation.
    public func didReceiveAbstractData(_ data: Any?) {
        guard let data = data as? DataType else { return }
        
        self.didReceiveData(data)
    }
}
