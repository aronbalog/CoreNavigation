import UIKit

public typealias ResponseSuccessBlock<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController> = (Response<FromViewController, ToViewController, EmbeddingViewController>) -> Void
public typealias ResponseFailureBlock = (Error) -> Void

public class NavigationConfiguration<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController>: TransitioningDelegatable, Eventable, DataPassable, StateRestorable {
    let configuration: Configuration.Base<FromViewController, ToViewController, EmbeddingViewController>

    init(with configuration: Configuration.Base<FromViewController, ToViewController, EmbeddingViewController>) {
        self.configuration = configuration
    }
    
    @discardableResult public func to<ToViewController>(_ viewController: ToViewController) -> NavigationConfiguration<FromViewController, ToViewController, EmbeddingViewController> {
        configuration.destination.target = viewController
        
        return cast(self, to: NavigationConfiguration<FromViewController, ToViewController, EmbeddingViewController>.self)
    }
    
    @discardableResult public func to<ToViewController>(_ viewControllerType: ToViewController.Type) -> NavigationConfiguration<FromViewController, ToViewController, EmbeddingViewController> {
        configuration.destination.target = viewControllerType
        
        return cast(self, to: NavigationConfiguration<FromViewController, ToViewController, EmbeddingViewController>.self)
    }
    
    @discardableResult public func embed<EmbeddingViewController: ViewControllerEmbedding>(in embeddableViewControllerType: EmbeddingViewController.Type) -> NavigationConfiguration<FromViewController, ToViewController, EmbeddingViewController> {
        configuration.embedding.embeddableViewControllerType = embeddableViewControllerType
        
        return cast(self, to: NavigationConfiguration<FromViewController, ToViewController, EmbeddingViewController>.self)
    }
    
    @discardableResult public func onSuccess(_ success: @escaping ResponseSuccessBlock<FromViewController, ToViewController, EmbeddingViewController>) -> Self {
        configuration.result.successBlocks.append(success)
        
        return self
    }
    
    @discardableResult public func onFailure(_ failure: @escaping ResponseFailureBlock) -> Self {
        configuration.result.failureBlocks.append(failure)
        
        return self
    }
    
    
    @discardableResult public func transitioningDelegate(_ transitioningDelegate: UIViewControllerTransitioningDelegate?) -> Self {
        configuration.transition.viewControllerTransitioningDelegate = transitioningDelegate
        
        return self
    }
    
    @discardableResult public func viewControllerEvents(_ viewControllerEventBlock: @escaping (ViewControllerEventable, UIViewController) -> Void) -> Self {
        configuration.event.viewControllerEventBlocks.append(viewControllerEventBlock)
        
        return self
    }
    
    @discardableResult public func pass(parameters: [String : Any]) -> Self {
        configuration.data.value.merge(parameters, uniquingKeysWith: { (oldValue, newValue) -> Any in
            return newValue
        })
    
        return self
    }
    
    @discardableResult public func withStateRestoration() -> Self {
        configuration.stateRestoration.option = .automatically
        
        return self
    }
    
    @discardableResult public func withStateRestoration(restorationIdentifier: String) -> Self {
        configuration.stateRestoration.option = .automaticallyWithIdentifier(restorationIdentifier: restorationIdentifier)
        
        return self
    }
    
    @discardableResult public func withManualStateRestoration(restorationIdentifier: String, restorationClass: UIViewControllerRestoration.Type) -> Self {
        configuration.stateRestoration.option = .manually(restorationIdentifier: restorationIdentifier, restorationClass: restorationClass)
        
        return self
    }
    
    func cast<T, U>(_ x: T, to type: U.Type) -> U {
        return unsafeBitCast(x, to: type)
    }
}
