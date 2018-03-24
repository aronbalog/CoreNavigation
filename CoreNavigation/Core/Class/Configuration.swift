import Foundation

typealias ConfigurationConformance = Transitionable &
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
    let destination: Destination
    let from: UIViewController?

    var transitioning = Transitioning()
    var embedding = Embedding()
    var dataPassing = DataPassing()
    var events = Events()
    var caching = Caching()
    var protection = Protection()
    var unsafeNavigation = UnsafeNavigationObject()
    var stateRestoration = StateRestoration()
    var application = Application()
    var origin = Origin()
    
    var event: Configuration<ResultableType>.Event {
        return Event(configuration: self)
    }

    var willNavigateBlocks: [(UIViewController) -> Void] = []
    
    init(destination: Destination, from: UIViewController?) {
        self.destination = destination
        self.from = from
    }
    
    class Transitioning: TransitioningAware {
        public var animated: Bool = true
        public var completionBlocks: [() -> Void] = []
        public var viewControllerTransitioningDelegate: UIViewControllerTransitioningDelegate?
    }
    
    class Embedding: EmbeddingAware {
        public var embeddingType: EmbeddingType?
    }
    
    class DataPassing: DataPassingAware {
        public var data: Any??
    }
    
    class Events: EventAware {
        enum NavigationEvent {
            case completion(() -> Void)
            case passData((ResultableType.DataType) -> Void)
            case viewController(ViewControllerEvent<ResultableType.ToViewController>)
        }
        
        public var navigationEvents: [NavigationEvent] = []
        var passDataBlocks: [Any] = []
    }
    
    class Caching: CachingAware {
        var configuration: (lifetime: Lifetime, cacheIdentifier: String)?
    }
    
    class Event {
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
    
    class Protection: ProtectionAware {
        var protectionSpace: ProtectionSpace?
    }
    
    class UnsafeNavigationObject: UnsafeNavigationAware {
        var isUnsafe: Bool = false
    }
    
    class StateRestoration: StateRestorationAware {
        var option: StateRestorationOption = .ignore
    }
    
    class Application: ApplicationAware {
        var application: UIApplicationProtocol = UIApplication.shared
    }
    
    class Origin: OriginAware {
        var fromViewController: UIViewController?
    }
}

extension UIApplication: UIApplicationProtocol {}

