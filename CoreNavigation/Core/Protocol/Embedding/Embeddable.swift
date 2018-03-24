import Foundation

protocol Embeddable: class {
    associatedtype Embedding: EmbeddingAware
    
    var embedding: Embedding { get set }
    
    @discardableResult func embedded(in type: EmbeddingType) -> Self
    @discardableResult func embedded(in embeddingProtocol: EmbeddingProtocol.Type) -> Self
    @discardableResult func embeddedInNavigationController() -> Self
}

extension Embeddable {
    @discardableResult public func embedded(in type: EmbeddingType) -> Self {
        embedding.embeddingType = type
        
        return self
    }
    
    @discardableResult public func embedded(in embeddingProtocol: EmbeddingProtocol.Type) -> Self {
        embedding.embeddingType = .embeddingProtocol(embeddingProtocol)
        
        return self
    }
    
    @discardableResult public func embeddedInNavigationController() -> Self {
        embedding.embeddingType = .navigationController
        
        return self
    }
}
