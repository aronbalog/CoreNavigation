import UIKit
#if ROUTING
import CoreRoute
#endif

class Navigator<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController> {
    typealias NavigationResponse = Response<FromViewController, ToViewController, EmbeddingViewController>
    
    private let configuration: Configuration.Base<FromViewController, ToViewController, EmbeddingViewController>
    
    init(configuration: Configuration.Base<FromViewController, ToViewController, EmbeddingViewController>) {
        self.configuration = configuration
    }
    
    @discardableResult func execute(_ completion: ((NavigationResponse?) -> Void)?) -> NavigationResponse? {
        // protect if needed
        if let protectionSpace = configuration.protection.protectionSpace {
            var execution: NavigationResponse?
            
            let shouldProtect = protectionSpace.shouldProtect(unprotect: {
                execution = self.execute(completion)
            }, failure: { (error) in
                self.configuration.result.failureBlocks.forEach({ (block) in
                    block(error)
                })
            })
            
            if shouldProtect {
                return execution
            }
        }
        
        guard let response: Response<FromViewController, ToViewController, EmbeddingViewController> = {
            switch configuration.action {
            case .present:
                return self.present(completion)
            case .push:
                return self.push(completion)
            case .response:
                return self.response()
            }
        }() else { return nil }
        
        configuration.result.successBlocks.forEach { (block) in
            block(response)
        }
        
        return nil
    }
    
    private func present(_ completion: ((NavigationResponse?) -> Void)?) -> NavigationResponse? {
        guard let fromViewController = fromViewController as? FromViewController else { return nil }
        
        var _response: NavigationResponse?
        
        func action(destinationViewController: UIViewController) {
            let animated = self.configuration.transition.animated ?? true
            fromViewController.present(destinationViewController, animated: animated, completion: { [weak self] in
                guard let `self` = self else { return }
                
                self.configuration.transition.completionBlocks.forEach({ (transitionCompletionBlock) in
                    transitionCompletionBlock()
                })
            })
        }
        
        guard let toViewController = getToViewController({ (toViewController) in
            if let toViewController = toViewController {
                _response = self.response(fromViewController: fromViewController, toViewController: toViewController, perform: true, action: { destinationViewController in
                    action(destinationViewController: destinationViewController)
                }, completion: completion)
            }
        }) else {
            return nil
        }
        
        if _response != nil {
            return _response
        }
        
        return self.response(fromViewController: fromViewController, toViewController: toViewController, perform: true, action: { destinationViewController in
            action(destinationViewController: destinationViewController)
        }, completion: completion)
    }
    
    private func push(_ completion: ((NavigationResponse?) -> Void)?) -> NavigationResponse? {
        
        guard
            let fromViewController = fromViewController as? FromViewController,
            let navigationController = fromViewController.navigationController ?? (fromViewController as? UINavigationController)
            else {
                return nil
        }
   
        var _response: NavigationResponse?
        
        func action(destinationViewController: UIViewController) {
            let animated = self.configuration.transition.animated ?? true
            
            navigationController.pushViewController(destinationViewController, animated: animated) { [weak self] in
                guard let `self` = self else { return }
                
                self.configuration.transition.completionBlocks.forEach({ (completion) in
                    completion()
                })
            }
        }
        
        guard let toViewController = getToViewController({ (toViewController) in
            if let toViewController = toViewController {
                _response = self.response(fromViewController: fromViewController, toViewController: toViewController, perform: true, action: { destinationViewController in
                    action(destinationViewController: destinationViewController)
                }, completion: completion)
            }
        }) else { return nil }
        
        if _response != nil {
            return _response
        }
        
        return self.response(fromViewController: fromViewController, toViewController: toViewController, perform: true, action: { destinationViewController in
            action(destinationViewController: destinationViewController)
        }, completion: completion)
    }
    
    private func response(fromViewController: FromViewController, toViewController: ToViewController, perform: Bool, action: (UIViewController) -> Void, completion: ((NavigationResponse?) -> Void)?) -> NavigationResponse? {
        let response = NavigationResponse(fromViewController: fromViewController, toViewController: toViewController, embeddingViewController: nil)
        response.parameters = configuration.data.value
        
        let destinationViewController = embeddingViewController(with: response) ?? toViewController
        
        let transitioningDelegate = configuration.transition.viewControllerTransitioningDelegate
        
        fromViewController.transitioningDelegate = transitioningDelegate
        if perform {
            cache(viewController: toViewController)
            bindEvents(to: toViewController)
            
            passResponse(response, to: toViewController)
            
            action(destinationViewController)
        }
        
        return response
    }
    
    private func response() -> Response<FromViewController, ToViewController, EmbeddingViewController>? {
        fatalError("not implemented yet")
    }
    
    private var fromViewController: UIViewController? {
        return
            (configuration.origin.fromViewController as? FromViewController) ??
            UIViewController.currentViewController
    }
    private func getToViewController(_ toViewControllerBlock: @escaping (ToViewController?) -> Void) -> ToViewController? {
        var cachedViewController: ToViewController? {
            guard let (_, identifier) = configuration.life.value else { return nil }
            
            let toViewController = Cache.shared.viewController(for: identifier) as? ToViewController
            toViewControllerBlock(toViewController)
            
            return toViewController
        }
        
        guard let target = configuration.destination.target else { return nil }
        
        
        let toViewController: ToViewController? = {
            if let viewController = target as? ToViewController {
                return viewController
            } else if let viewControllerClass = target as? ToViewController.Type {
                return viewControllerClass.init(nibName: nil, bundle: nil)
            }
            
            return nil
        }()
        
        #if ROUTING
        func _route(to route: AbstractRoute, in router: Router) -> ToViewController? {
            let request = Request<String, Any?>(route: route.routePath)
            
            var _toViewController: ToViewController?
            
            router.request(request)
                .onSuccess({ (response) in
                    if let destination = response.destination as? ToViewController {
                        _toViewController = destination
                    } else if let destination = response.destination as? ToViewController.Type {
                        _toViewController = destination.init(nibName: nil, bundle: nil)
                    }
                    
                    toViewControllerBlock(_toViewController)
                })
                .execute()
            
            return _toViewController
        }
        #endif
        
        guard let viewController = cachedViewController ?? toViewController else {
            #if ROUTING
            if let (route, router) = target as? (AbstractRoute, Router) {
                if let _toViewController = _route(to: route, in: router) {
                    return _toViewController
                }
            }
            #endif
            
            return nil
        }
        
        return viewController
    }
    private func embeddingViewController(with response: NavigationResponse) -> EmbeddingViewController? {
        guard let type = configuration.embedding.embeddableViewControllerType else { return nil }
        
        let _response = unsafeDowncast(response, to: Response<UIViewController, UIViewController, UIViewController>.self)
        
        let embeddingViewController: EmbeddingViewController? = (type.init(with: _response) as? EmbeddingViewController)
        
        response.embeddingViewController = embeddingViewController
        
        if let embeddingViewController = embeddingViewController {
            passResponse(response, to: embeddingViewController)
        }
        
        return embeddingViewController
    }
    
    // helpers
    
    private func passResponse(_ response: Response<FromViewController, ToViewController, EmbeddingViewController>, to viewController: UIViewController) {
        if let responseAware = viewController as? ResponseAware {
            let response = unsafeDowncast(response, to: Response<UIViewController, UIViewController, UIViewController>.self)
            responseAware.didReceiveResponse(response)
        }
    }
    
    private func bindEvents(to viewController: UIViewController) {
        // append events
        let viewControllerEvents = ViewControllerEvents()
        let event = configuration.event
        
        event.viewControllerEventBlocks.forEach { (eventBlock) in
            eventBlock(event, viewController)
        }
        event.bind(viewControllerEvents)
        viewController.events = viewControllerEvents
    }
    
    private func cache(viewController: UIViewController) {
        if
            let (lifetime, identifier) = configuration.life.value
        {
            Cache.shared.add(identifier: identifier, viewController: viewController, lifetime: lifetime)
        }
    }
}
