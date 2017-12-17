import UIKit

public class NavigationAction<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController>: NavigationConfiguration<FromViewController, ToViewController, EmbeddingViewController>, Transitionable, Cachable, Protectable {
    @discardableResult public func from<FromViewController>(_ viewController: FromViewController) -> NavigationAction<FromViewController, ToViewController, EmbeddingViewController> {
        configuration.origin.fromViewController = viewController
        
        return cast(self, to: NavigationAction<FromViewController, ToViewController, EmbeddingViewController>.self)
    }
    
    @discardableResult public func to<ToViewController>(_ viewController: ToViewController) -> NavigationAction<FromViewController, ToViewController, EmbeddingViewController> {
        configuration.destination.target = viewController
        
        return cast(self, to: NavigationAction<FromViewController, ToViewController, EmbeddingViewController>.self)
    }
    
    @discardableResult public func to<ToViewController>(_ viewControllerType: ToViewController.Type) -> NavigationAction<FromViewController, ToViewController, EmbeddingViewController> {
        configuration.destination.target = viewControllerType

        return cast(self, to: NavigationAction<FromViewController, ToViewController, EmbeddingViewController>.self)
    }
    
    @discardableResult public func animated(_ animated: Bool) -> Self {
        configuration.transition.animated = animated
        
        return self
    }
    
    @discardableResult public func completion(_ completion: @escaping () -> Void) -> Self {
        configuration.transition.completionBlocks.append(completion)
        
        return self
    }
    
    @discardableResult public func keepAlive(within lifetime: Lifetime, identifier: String) -> Self {
        configuration.life.value = (lifetime, identifier)
        
        return self
    }
}
