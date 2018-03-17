import Foundation

public class ProtectionHandler {
    var unprotectBlocks: [() -> Void] = []
    
    public func unprotect() {
        unprotectBlocks.forEach { $0() }
    }
    
    func onUnprotect(_ block: @escaping () -> Void) {
        unprotectBlocks.append(block)
    }
}
