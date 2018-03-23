import Foundation

public typealias ConfigurationConformance = Transitionable &
                                            Embeddable &
                                            DataPassable &
                                            Eventable &
                                            Cacheable &
                                            Protectable &
                                            UnsafeNavigation &
                                            StateRestorable &
                                            Application &
                                            Originable

public final class Configuration<ResultableType: Resultable>: ConfigurationConformance {
    public let destination: Destination
    public let from: UIViewController?

    public var transitioning = Transitioning()
    public var embedding = Embedding()
    public var dataPassing = DataPassing()
    public var events = Events()
    public var caching = Caching()
    public var protection = Protection()
    public var unsafeNavigation = UnsafeNavigationObject()
    public var stateRestoration = StateRestoration()
    public var application = Application()
    public var origin = Origin()
    
    public var event: Configuration<ResultableType>.Event {
        return Event(configuration: self)
    }

    var willNavigateBlocks: [(UIViewController) -> Void] = []
    
    init(destination: Destination, from: UIViewController?) {
        self.destination = destination
        self.from = from
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
        public var data: Any??
    }
    
    public class Events: EventAware {
        public enum NavigationEvent {
            case completion(() -> Void)
            case passData((ResultableType.DataType) -> Void)
            case viewController(ViewControllerEvent<ResultableType.ToViewController>)
        }
        
        public var navigationEvents: [NavigationEvent] = []
        var passDataBlocks: [Any] = []
    }
    
    public class Caching: CachingAware {
        public var configuration: (lifetime: Lifetime, cacheIdentifier: String)?
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
    
    public class StateRestoration: StateRestorationAware {
        public var option: StateRestorationOption = .ignore
    }
    
    public class Application: ApplicationAware {
        public var application: UIApplicationProtocol = UIApplication.shared
    }
    
    public class Origin: OriginAware {
        public var fromViewController: UIViewController?
    }
}

extension UIApplication: UIApplicationProtocol {}

