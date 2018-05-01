import Foundation

/// Handles protection.
public class ProtectionHandler {
    var unprotectBlocks: [() -> Void] = []
    var cancelBlocks: [(Error?) -> Void] = []
    
    /// Notifies handler to continue with navigation.
    public func unprotect() {
        unprotectBlocks.forEach { $0() }
    }
    
    /// Notifies handler to cancel navigation with error.
    ///
    /// - Parameter error: Error object.
    public func cancel(error: Error? = nil) {
        cancelBlocks.forEach { $0(error) }
    }

    func onUnprotect(_ block: @escaping () -> Void) {
        unprotectBlocks.append(block)
    }
    
    func onCancel(_ block: @escaping (Error?) -> Void) {
        cancelBlocks.append(block)
    }
}
