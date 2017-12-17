import UIKit

public typealias ResponseSuccessBlock<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController> = (Response<FromViewController, ToViewController, EmbeddingViewController>) -> Void
public typealias ResponseFailureBlock = (Error) -> Void

public class NavigationConfiguration<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController>: TransitioningDelegatable, Eventable {
    
    let configuration: Configuration.Base<FromViewController, ToViewController, EmbeddingViewController>

    init(with configuration: Configuration.Base<FromViewController, ToViewController, EmbeddingViewController>) {
        self.configuration = configuration
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
    
    func cast<T, U>(_ x: T, to type: U.Type) -> U {
        return unsafeBitCast(x, to: type)
    }
}
