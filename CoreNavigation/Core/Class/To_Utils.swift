import Foundation

extension To {
    func cast<T>(_ x: Swift.AnyObject, to type: T.Type) -> T where T : AnyObject {
        return unsafeBitCast(x, to: type)
    }
}
