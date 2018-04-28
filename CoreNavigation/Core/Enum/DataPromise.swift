import Foundation

enum DataPromise<T: Resultable> {
    case sync(T.DataType?)
    case async(((T.DataType?) -> Void) -> Void)
    case none

    init(dataPassing: Configuration<T>.DataPassing) {
        if let data = dataPassing.data as? T.DataType {
            self = .sync(data)
        } else if let dataBlock = dataPassing.dataBlock as? ((T.DataType) -> Void) -> Void {
            self = .async(dataBlock)
        } else {
            self = .none
        }
    }
}
