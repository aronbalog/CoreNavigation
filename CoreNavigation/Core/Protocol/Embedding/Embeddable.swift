import Foundation

public protocol Embeddable: class {
    associatedtype Embedding: EmbeddingAware
    
    var embedding: Embedding { get set }
    
    @discardableResult func embed(in type: EmbeddingType) -> Self
    @discardableResult func embed(in embeddingProtocol: EmbeddingProtocol.Type) -> Self
    @discardableResult func embedInNavigationController() -> Self
}

extension Embeddable {
    @discardableResult public func embed(in type: EmbeddingType) -> Self {
        embedding.embeddingType = type
        
        return self
    }
    
    @discardableResult public func embed(in embeddingProtocol: EmbeddingProtocol.Type) -> Self {
        embedding.embeddingType = .embeddingProtocol(embeddingProtocol)
        
        return self
    }
    
    @discardableResult public func embedInNavigationController() -> Self {
        embedding.embeddingType = .navigationController
        
        return self
    }
}
