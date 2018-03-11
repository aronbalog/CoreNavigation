import Foundation

public typealias ConfigurationConformance = Transitionable

public final class Configuration<ResultableType: Resultable>: ConfigurationConformance {
    public let destination: Destination
    
    public class Transition: TransitionAware {
        public var animated: Bool = true
        public var completionBlocks: [() -> Void] = []
    }
    
    public var transition = Transition()
    
    init(destination: Destination) {
        self.destination = destination
    }
}
