class Configuration<DestinationType: Destination, FromType: UIViewController> {
    typealias OnSuccessBlock = (Result<DestinationType, FromType>) -> Void
    typealias OnCompletionBlock = (Result<DestinationType, FromType>) -> Void
    typealias OnFailureBlock = (Error) -> Void
    typealias DataPassingBlock<T> = (DataPassing.Context<T>) -> Void
    typealias CachingBlock = () -> (String, Cacheable)
    
    let navigationDirection: NavigationDirection
    private var toBlock: () -> DestinationType
    lazy var destination: DestinationType = {
        return toBlock()
    }()
    
    var sourceViewController: FromType
    var isAnimatedBlock: () -> Bool = { true }
    var dataPassingBlock: DataPassingBlock<Any>?
    var onSuccessBlocks: [OnSuccessBlock] = []
    var onCompletionBlocks: [OnCompletionBlock] = []
    var onFailureBlocks: [OnFailureBlock] = []
    var protections: [Protectable] = []
    var embeddable: Embeddable?
    var cachingBlock: CachingBlock?
    
    init(navigationDirection: NavigationDirection, toBlock: @escaping () -> DestinationType, from sourceViewController: FromType) {
        self.navigationDirection = navigationDirection
        self.toBlock = toBlock
        self.sourceViewController = sourceViewController
    }
}
