import Foundation

/// Describes view controller which can receive data.
public protocol DataReceivingViewController: DataReceiving where Self: UIViewController {
    associatedtype DataType
    
    /// Called by module when data passing occurs.
    ///
    /// - Parameter data: Data passed on navigation.
    func didReceiveData(_ data: DataType)
}

// MARK: - DataReceivingViewController default implementation
extension DataReceivingViewController {
    /// Called by module when data passing occurs.
    ///
    /// - Parameter data: Data passed on navigation.
    public func didReceiveAbstractData(_ data: Any?) {
        guard let data = data as? DataType else { return }
        
        self.didReceiveData(data)
    }
}
