public class Configuration<DestinationType: Destination, FromType: UIViewController> {
    typealias OnSuccessBlock = (Navigation.Result<DestinationType, FromType>) -> Void
    typealias OnCompletionBlock = (Navigation.Result<DestinationType, FromType>) -> Void
    typealias OnFailureBlock = (Error) -> Void
    typealias ViewControllerEventBlock = () -> [UIViewController.Event<DestinationType.ViewControllerType>]
    typealias DataPassingBlock<T> = (DataPassing.Context<T>) -> Void
    typealias DataReturningBlock<T> = (T, UIViewController) -> Void
    typealias CachingBlock = () -> (String, Cacheable)
    typealias TransitioningDelegateBlock = () -> UIViewControllerTransitioningDelegate?
    typealias IsAnimatedBlock = () -> Bool
    typealias StateRestorationBlock = () -> (identifier: String, expirationDate: Date)
    typealias DelayBlock = () -> TimeInterval
    typealias PrepareForSegueBlock = (UIStoryboardSegue, Any?) -> Void
    typealias ModalPresentationStyleBlock = () -> UIModalPresentationStyle
    typealias ModalTransitionStyleBlock = () -> UIModalTransitionStyle
    typealias IsModalInPresentationBlock = () -> Bool

    let directive: Directive
    private var toBlock: () -> DestinationType
    lazy var destination: DestinationType = {
        toBlock()
    }()

    var sourceViewController: FromType
    var isAnimatedBlock: IsAnimatedBlock = { true }
    var transitioningDelegateBlock: TransitioningDelegateBlock?
    var dataPassingBlock: DataPassingBlock<Any?>?
    var dataReturningBlocks: [DataReturningBlock<Any?>] = []
    var backDataPassingElements: [(UIViewController.Type, DataPassingBlock<Any?>)] = []
    var onSuccessBlocks: [OnSuccessBlock] = []
    var onCompletionBlocks: [OnCompletionBlock] = []
    var onFailureBlocks: [OnFailureBlock] = []
    var viewControllerEventBlocks: [ViewControllerEventBlock] = []
    var protections: [Protectable] = []
    var embeddable: Embeddable?
    var cachingBlock: CachingBlock?
    var stateRestorationBlock: StateRestorationBlock?
    var prepareForSegueBlock: PrepareForSegueBlock?
    var delayBlock: DelayBlock?
    var modalPresentationStyleBlock: ModalPresentationStyleBlock = {
        if #available(iOS 13, *) {
            return .automatic
        }
        
        return .fullScreen
    }
    var modalTransitionStyleBlock: ModalTransitionStyleBlock = {
        .coverVertical
    }
    
    var isModalInPresentationBlock: IsModalInPresentationBlock?

    init(directive: Directive, toBlock: @escaping () -> DestinationType, from sourceViewController: FromType) {
        self.directive = directive
        self.toBlock = toBlock
        self.sourceViewController = sourceViewController
    }
}
