import Foundation

public protocol DataPassable: class {
    associatedtype DataPassing: DataPassingAware
    
    var dataPassing: DataPassing { get set }
    
    @discardableResult func pass(_ data: Any) -> Self
}

extension DataPassable {
//    @discardableResult public func pass(_ data: Any?) -> Self {
//        dataPassing.data = data
//        
//        return self
//    }
}
