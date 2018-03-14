import Foundation

public typealias ConfigurationConformance = Transitionable & Embeddable & DataPassable & Eventable

public final class Configuration<ResultableType: Resultable>: ConfigurationConformance {
    
    public let destination: Destination
    
    public var transitioning = Transitioning()
    public var embedding = Embedding()
    public var dataPassing = DataPassing()
    public var events = Events()
    public var event: Configuration<ResultableType>.Event {
        return Event(configuration: self)
    }

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
    
    public class Events: EventAware {
        public var navigationEvents: [NavigationEvent] = []
        var dataPassBlocks: [Any] = []
    }
    
    public class Event {
        unowned var configuration: Configuration
        
        init(configuration: Configuration) {
            self.configuration = configuration
        }
        
        public func completion(_ block: @escaping () -> Void) -> Configuration {
            configuration.on(.completion(block))
            
            return configuration
        }
    }
}

extension Configuration where ResultableType.ToViewController: DataReceivable {
    @discardableResult public func pass(_ parameters: ResultableType.ToViewController.DataType) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>> {
        if dataPassing.data == nil {
            dataPassing.data = parameters
        }
        
        willNavigateBlocks.append { (viewController) in
            let data = self.dataPassing.data as! ResultableType.ToViewController.DataType
            (viewController as! ResultableType.ToViewController).didReceiveData(data)
            self.events.navigationEvents.forEach({ (event) in
                if case NavigationEvent.passData(let block) = event {
                    block(data)
                }
            })
                        
            (self.events.dataPassBlocks as? [(ResultableType.ToViewController.DataType) -> Void])?.forEach { block in
                block(data)
            }
        }
        
        return cast(self, to: Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>>.self)
    }
}

extension Configuration.Event where ResultableType.ToViewController: DataReceivable {
    public func passData(_ block: @escaping (ResultableType.ToViewController.DataType) -> Void) -> Configuration {
        configuration.events.dataPassBlocks.append(block)
        
        return configuration
    }
}
