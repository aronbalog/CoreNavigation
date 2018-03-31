import Foundation

/// Handles protection.
public class ProtectionHandler {
    var unprotectBlocks: [() -> Void] = []
    
    /// Notifies handler to continue with navigation.
    public func unprotect() {
        unprotectBlocks.forEach { $0() }
    }
    
    func onUnprotect(_ block: @escaping () -> Void) {
        unprotectBlocks.append(block)
    }
}
