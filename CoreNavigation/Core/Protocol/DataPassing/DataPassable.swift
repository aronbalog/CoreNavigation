import Foundation

public protocol DataPassable: class {
    associatedtype DataPassing: DataPassingAware
    
    var dataPassing: DataPassing { get set }
    
    @discardableResult func pass(_ parameters: Any) -> Self
}

extension DataPassable {
    @discardableResult public func pass(_ parameters: Any) -> Self {
        dataPassing.data = parameters
        
        return self
    }
}
