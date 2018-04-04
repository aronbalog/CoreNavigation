import Foundation

extension Configuration {    
    /// Observe navigation success.
    ///
    /// - Parameter success: Success block.
    /// - Returns: Configuration instance.
    @discardableResult public func onSuccess(_ success: @escaping (ResultableType) -> Void) -> Self {
        successBlocks.append(success)
        
        return self
    }
    
    /// Observe navigation failure.
    ///
    /// - Parameter failure: Failure block.
    /// - Returns: Configuration instance.
    @discardableResult public func onFailure(_ failure: @escaping (Error) -> Void) -> Self {
        failureBlocks.append(failure)
        
        return self
    }
}
