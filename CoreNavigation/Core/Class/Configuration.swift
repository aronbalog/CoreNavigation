import Foundation

public typealias ConfigurationConformance = Transitionable & Embeddable & DataPassable

public final class Configuration<ResultableType: Resultable>: ConfigurationConformance {
    public let destination: Destination
    
    public var transitioning = Transitioning()
    public var embedding = Embedding()
    public var dataPassing = DataPassing()

    var willNavigateBlocks: [(UIViewController) -> Void] = []
    
    init(destination: Destination) {
        self.destination = destination
    }
    
    public class Transitioning: TransitioningAware {
        public var animated: Bool = true
        public var completionBlocks: [() -> Void] = []
    }
    
    public class Embedding: EmbeddingAware {
        public var embeddingType: EmbeddingType?
    }
    
    public class DataPassing: DataPassingAware {
        public var parameters: Any?
    }
}

extension Configuration where ResultableType.ToViewController: ParametersAware {
    @discardableResult public func pass(_ parameters: ResultableType.ToViewController.ParametersType) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.ParametersType>> {
        dataPassing.parameters = parameters
        
        willNavigateBlocks.append { (viewController) in
            (viewController as! ResultableType.ToViewController).didReceiveParameters(parameters)
        }
        
        return cast(self, to: Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.ParametersType>>.self)
    }
}
