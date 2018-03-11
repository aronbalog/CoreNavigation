import Foundation

extension Int {
    @discardableResult mutating func invoke() -> Int {
        self += 1
        
        return self
    }
    
    var isInvokedOnce: Bool {
        return self == 1
    }
}
