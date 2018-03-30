import Foundation


public enum NavigationEvent<ToViewController: UIViewController, DataType> {
    case completion(() -> Void)
    case passData((DataType) -> Void)
    case viewController(ViewControllerEvent<ToViewController>)
}

/// Acts as storage for navigation parameters.
public final class Configuration<ResultableType: Resultable> {
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
        public var navigationEvents: [NavigationEvent<ResultableType.ToViewController, ResultableType.DataType>] = []
        var passDataBlocks: [Any] = []
    }
    
    class Caching: CachingAware {
        var configuration: (lifetime: Lifetime, cacheIdentifier: String)?
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

