import Foundation

public protocol DataPassable: class {
    associatedtype DataPassing: DataPassingAware
    
    var dataPassing: DataPassing { get set }
}
