import Foundation

protocol Embeddable: class {
    associatedtype Embedding: EmbeddingAware
    
    var embedding: Embedding { get set }
    
    @discardableResult func embedded(in type: EmbeddingType) -> Self
    @discardableResult func embedded(in embeddingProtocol: EmbeddingProtocol.Type) -> Self
    @discardableResult func embeddedInNavigationController() -> Self
}

extension Configuration: Embeddable {
    /// Embeds destination view controller.
    ///
    /// - Parameter type: Embedding type.
    /// - Returns: Configuration instance.
    @discardableResult public func embedded(in type: EmbeddingType) -> Self {
        queue.async(flags: .barrier) {
            self.embedding.embeddingType = type
        }
        
        return self
    }
    
    /// Embeds destination view controller.
    ///
    /// - Parameter embeddingProtocol: EmbeddingProtocol type.
    /// - Returns: Configuration instance.
    @discardableResult public func embedded(in embeddingProtocol: EmbeddingProtocol.Type) -> Self {
        queue.async(flags: .barrier) {
            self.embedding.embeddingType = .embeddingProtocol(embeddingProtocol)
        }
        
        return self
    }
    
    /// Embeds destination view controller.
    ///
    /// - Returns: Configuration instance.
    @discardableResult public func embeddedInNavigationController() -> Self {
        queue.async(flags: .barrier) {
            self.embedding.embeddingType = .navigationController
        }
        
        return self
    }
}
