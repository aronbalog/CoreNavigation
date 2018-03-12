import Foundation

public protocol EmbeddingAware: class {
    var embeddingType: EmbeddingType? { get set }
}
