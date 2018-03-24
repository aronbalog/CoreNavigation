import Foundation

protocol EmbeddingAware: class {
    var embeddingType: EmbeddingType? { get set }
}
