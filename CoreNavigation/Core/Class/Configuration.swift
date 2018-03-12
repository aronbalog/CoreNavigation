import Foundation

public typealias ConfigurationConformance = Transitionable & Embeddable

public final class Configuration<ResultableType: Resultable>: ConfigurationConformance {
    public let destination: Destination
    
    public class Transitioning: TransitioningAware {
        public var animated: Bool = true
        public var completionBlocks: [() -> Void] = []
    }
    
    public class Embedding: EmbeddingAware {
        public var embeddingType: EmbeddingType?
    }
    
    public var transitioning = Transitioning()
    public var embedding = Embedding()

    init(destination: Destination) {
        self.destination = destination
    }
}
