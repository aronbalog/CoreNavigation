import Foundation

protocol DataPassingAware {
    var data: Any?? { get set }
    var dataBlock: Any? { get set }
}
