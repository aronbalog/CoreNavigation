import UIKit
#if ROUTING
import CoreRoute
#endif

public struct Configuration {
    public typealias Push = NavigationAction<UIViewController, UIViewController, UIViewController>
    public typealias Present = NavigationAction<UIViewController, UIViewController, UIViewController>
    public typealias Response = NavigationConfiguration<UIViewController, UIViewController, UIViewController>
    
    class Base<FromViewController: UIViewController, ToViewController: UIViewController, EmbeddingViewController: UIViewController> {
        let action: Action
        let origin = Origin()
        let destination = Destination()
        let embedding = Embedding()
        let transition = Transition()
        let event = Event()
        let result = Result()
        let life = Life()
        let data = Data()
        let protection = Protection()
        let stateRestoration = StateRestoration()
        
        init(action: Action) {
            self.action = action
        }
        
        enum Action {
            case present
            case push
            case response
        }
        class Origin {
            var fromViewController: UIViewController?
        }
        class Destination {
            var target: Any?
        }
        class Embedding {
            var embeddableViewControllerType: ViewControllerEmbedding.Type?
        }
        class Transition {
            var animated: Bool?
            var completionBlocks: [(() -> Void)] = []
            var viewControllerTransitioningDelegate: UIViewControllerTransitioningDelegate?
            var hidesBottomBarWhenPushed: Bool?
        }
        class Result {
            var successBlocks: [ResponseSuccessBlock<FromViewController, ToViewController, EmbeddingViewController>] = []
            var failureBlocks: [ResponseFailureBlock] = []
        }
        class Life {
            var value: (Lifetime, String)?
        }
        class Data {
            var value: [String: Any] = [:]
        }
        class Protection {
            var protectionSpace: ProtectionSpace?
        }
        class StateRestoration {
            enum Option {
                case ignore
                case automatically
                case automaticallyWithIdentifier(restorationIdentifier: String)
                case manually(restorationIdentifier: String, restorationClass: UIViewControllerRestoration.Type?)
            }
            var option: Option = .ignore
        }
        class Event: ViewControllerEventable {
            var viewControllerEventBlocks: [(ViewControllerEventable, UIViewController) -> Void] = []
            var onLoadViewBlocks: [(() -> Void)] = []
            var onViewDidLoadBlocks: [(() -> Void)] = []
            var onViewWillAppearBlocks: [((Bool) -> Void)] = []
            var onViewDidAppearBlocks: [((Bool) -> Void)] = []
            var onViewWillDisappearBlocks: [((Bool) -> Void)] = []
            var onViewDidDisappearBlocks: [((Bool) -> Void)] = []
            var onViewWillTransitionBlocks: [((CGSize, UIViewControllerTransitionCoordinator) -> Void)] = []
            var onViewWillLayoutSubviewsBlocks: [(() -> Void)] = []
            var onViewDidLayoutSubviewsBlocks: [(() -> Void)] = []
            var onUpdateViewConstraintsBlocks: [(() -> Void)] = []
            var onWillMoveToBlocks: [((UIViewController?) -> Void)] = []
            var onDidMoveToBlocks: [((UIViewController?) -> Void)] = []
            var onDidReceiveMemoryWarningBlocks: [(() -> Void)] = []
            var onApplicationFinishedRestoringStateBlocks: [(() -> Void)] = []
            var onViewLayoutMarginsDidChangeBlocks: [(() -> Void)] = []
            var onViewSafeAreaInsetsDidChangeBlocks: [(() -> Void)] = []

            @discardableResult func loadView(_ loadView: @escaping () -> Void) -> ViewControllerEventable {
                onLoadViewBlocks.append(loadView)
                
                return self
            }
            
            @discardableResult func viewDidLoad(_ viewDidLoad: @escaping () -> Void) -> ViewControllerEventable {
                onViewDidLoadBlocks.append(viewDidLoad)
                
                return self
            }
            
            @discardableResult func viewWillAppear(_ viewWillAppear: @escaping (Bool) -> Void) -> ViewControllerEventable {
                onViewWillAppearBlocks.append(viewWillAppear)
                
                return self
            }
            
            @discardableResult func viewDidAppear(_ viewDidAppear: @escaping (Bool) -> Void) -> ViewControllerEventable {
                onViewDidAppearBlocks.append(viewDidAppear)
                
                return self
            }
            
            @discardableResult func viewWillDisappear(_ viewWillDisappear: @escaping (Bool) -> Void) -> ViewControllerEventable {
                onViewWillDisappearBlocks.append(viewWillDisappear)
                
                return self
            }
            
            @discardableResult func viewDidDisappear(_ viewDidDisappear: @escaping (Bool) -> Void) -> ViewControllerEventable {
                onViewDidDisappearBlocks.append(viewDidDisappear)
                
                return self
            }
            
            @discardableResult func viewWillTransition(_ viewWillTransition: @escaping (CGSize, UIViewControllerTransitionCoordinator) -> Void) -> ViewControllerEventable {
                onViewWillTransitionBlocks.append(viewWillTransition)
                
                return self
            }
            
            @discardableResult func viewWillLayoutSubviews(_ viewWillLayoutSubviews: @escaping () -> Void) -> ViewControllerEventable {
                onViewWillLayoutSubviewsBlocks.append(viewWillLayoutSubviews)
                
                return self
            }
            
            @discardableResult func viewDidLayoutSubviews(_ viewDidLayoutSubviews: @escaping () -> Void) -> ViewControllerEventable {
                onViewDidLayoutSubviewsBlocks.append(viewDidLayoutSubviews)
                
                return self
            }
            
            @discardableResult func updateViewConstraints(_ updateViewConstraints: @escaping () -> Void) -> ViewControllerEventable {
                onUpdateViewConstraintsBlocks.append(updateViewConstraints)
                
                return self
            }
            
            @discardableResult func willMoveTo(_ willMoveTo: @escaping (UIViewController?) -> Void) -> ViewControllerEventable {
                onWillMoveToBlocks.append(willMoveTo)
                
                return self
            }
            
            @discardableResult func didMoveTo(_ didMoveTo: @escaping (UIViewController?) -> Void) -> ViewControllerEventable {
                onDidMoveToBlocks.append(didMoveTo)
                
                return self
            }
            
            @discardableResult func didReceiveMemoryWarning(_ didReceiveMemoryWarning: @escaping () -> Void) -> ViewControllerEventable {
                onDidReceiveMemoryWarningBlocks.append(didReceiveMemoryWarning)
                
                return self
            }
            
            @discardableResult func applicationFinishedRestoringState(_ applicationFinishedRestoringState: @escaping () -> Void) -> ViewControllerEventable {
                onApplicationFinishedRestoringStateBlocks.append(applicationFinishedRestoringState)
                
                return self
            }
            
            @discardableResult func viewLayoutMarginsDidChange(_ viewLayoutMarginsDidChange: @escaping () -> Void) -> ViewControllerEventable {
                onViewLayoutMarginsDidChangeBlocks.append(viewLayoutMarginsDidChange)
                
                return self
            }
            
            @discardableResult func viewSafeAreaInsetsDidChange(_ viewSafeAreaInsetsDidChange: @escaping () -> Void) -> ViewControllerEventable {
                onViewSafeAreaInsetsDidChangeBlocks.append(viewSafeAreaInsetsDidChange)
                
                return self
            }
            
            func bind(_ viewControllerEvents: ViewControllerEvents) {
                onLoadViewBlocks.forEach { viewControllerEvents.onLoadView($0) }
                onViewDidLoadBlocks.forEach { viewControllerEvents.onViewDidLoad($0) }
                onViewWillAppearBlocks.forEach { viewControllerEvents.onViewWillAppear($0) }
                onViewDidAppearBlocks.forEach { viewControllerEvents.onViewDidAppear($0) }
                onViewWillDisappearBlocks.forEach { viewControllerEvents.onViewWillDisappear($0) }
                onViewDidDisappearBlocks.forEach { viewControllerEvents.onViewDidDisappear($0) }
                onViewWillTransitionBlocks.forEach { viewControllerEvents.onViewWillTransition($0) }
                onViewWillLayoutSubviewsBlocks.forEach { viewControllerEvents.onViewWillLayoutSubviews($0) }
                onViewDidLayoutSubviewsBlocks.forEach { viewControllerEvents.onViewDidLayoutSubviews($0) }
                onUpdateViewConstraintsBlocks.forEach { viewControllerEvents.onUpdateViewConstraints($0) }
                onWillMoveToBlocks.forEach { viewControllerEvents.onWillMoveTo($0) }
                onDidMoveToBlocks.forEach { viewControllerEvents.onDidMoveTo($0) }
                onDidReceiveMemoryWarningBlocks.forEach { viewControllerEvents.onDidReceiveMemoryWarning($0) }
                onApplicationFinishedRestoringStateBlocks.forEach { viewControllerEvents.onApplicationFinishedRestoringState($0) }
                onViewLayoutMarginsDidChangeBlocks.forEach { viewControllerEvents.onViewLayoutMarginsDidChange($0) }
                onViewSafeAreaInsetsDidChangeBlocks.forEach { viewControllerEvents.onViewSafeAreaInsetsDidChange($0) }
            }
        }
       
    }
}
