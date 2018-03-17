import Foundation

public typealias ConfigurationConformance = Transitionable &
                                            Embeddable &
                                            DataPassable &
                                            Eventable &
                                            Cacheable &
                                            Protectable &
                                            UnsafeNavigation

public final class Configuration<ResultableType: Resultable>: ConfigurationConformance {
    public let destination: Destination
    
    public var transitioning = Transitioning()
    public var embedding = Embedding()
    public var dataPassing = DataPassing()
    public var events = Events()
    public var caching = Caching()
    public var protection = Protection()
    public var unsafeNavigation = UnsafeNavigationObject()
    
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
        public var viewControllerTransitioningDelegate: UIViewControllerTransitioningDelegate?
    }
    
    public class Embedding: EmbeddingAware {
        public var embeddingType: EmbeddingType?
    }
    
    public class DataPassing: DataPassingAware {
        public var data: Any?
    }
    
    public class Events: EventAware {
        public enum NavigationEvent {
            case completion(() -> Void)
            case passData((Any) -> Void)
            case viewController(ViewControllerEvent<ResultableType.ToViewController>)
        }
        
        public var navigationEvents: [NavigationEvent] = []
        var passDataBlocks: [Any] = []
    }
    
    public class Caching: CachingAware {
        public var lifetime: Lifetime?
    }
    
    public class Event {
        unowned var configuration: Configuration
        
        init(configuration: Configuration) {
            self.configuration = configuration
        }
        
        @discardableResult public func completion(_ block: @escaping () -> Void) -> Configuration {
            configuration.on(.completion(block))
            
            return configuration
        }
        
        @discardableResult public func viewController(_ event: ViewControllerEvent<ResultableType.ToViewController>) -> Configuration {
            configuration.on(.viewController(event))
            
            return configuration
        }
    }
    
    public class Protection: ProtectionAware {
        public var protectionSpace: ProtectionSpace?
    }
    
    public class UnsafeNavigationObject: UnsafeNavigationAware {
        public var isUnsafe: Bool = false
    }

}

