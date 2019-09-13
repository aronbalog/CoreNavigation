class Configuration<DestinationType: Destination, FromType: UIViewController> {
    typealias OnSuccessBlock = (Navigation.Result<DestinationType, FromType>) -> Void
    typealias OnCompletionBlock = (Navigation.Result<DestinationType, FromType>) -> Void
    typealias OnFailureBlock = (Error) -> Void
    typealias ViewControllerEventBlock = () -> [UIViewController.Event<DestinationType.ViewControllerType>]
    typealias DataPassingBlock<T> = (DataPassing.Context<T>) -> Void
    typealias CachingBlock = () -> (String, Cacheable)
    typealias TransitioningDelegateBlock = () -> UIViewControllerTransitioningDelegate?
    typealias IsAnimatedBlock = () -> Bool
    
    let directive: Directive
    private var toBlock: () -> DestinationType
    lazy var destination: DestinationType = {
        return toBlock()
    }()
    
    var sourceViewController: FromType
    var isAnimatedBlock: IsAnimatedBlock = { true }
    var transitioningDelegateBlock: TransitioningDelegateBlock?
    var dataPassingBlock: DataPassingBlock<Any>?
    var onSuccessBlocks: [OnSuccessBlock] = []
    var onCompletionBlocks: [OnCompletionBlock] = []
    var onFailureBlocks: [OnFailureBlock] = []
    var viewControllerEventBlocks: [ViewControllerEventBlock] = []
    var protections: [Protectable] = []
    var embeddable: Embeddable?
    var cachingBlock: CachingBlock?
    
    init(directive: Directive, toBlock: @escaping () -> DestinationType, from sourceViewController: FromType) {
        self.directive = directive
        self.toBlock = toBlock
        self.sourceViewController = sourceViewController
    }
}
