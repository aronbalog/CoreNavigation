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
        public var data: Any?
    }
}

extension Configuration where ResultableType.ToViewController: DataReceivable {
    @discardableResult public func pass(_ parameters: ResultableType.ToViewController.DataType) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>> {
        if dataPassing.data == nil {
            dataPassing.data = parameters
        }
        
        willNavigateBlocks.append { (viewController) in
            (viewController as! ResultableType.ToViewController).didReceiveData(self.dataPassing.data as! ResultableType.ToViewController.DataType)
        }
        
        return cast(self, to: Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>>.self)
    }
}
