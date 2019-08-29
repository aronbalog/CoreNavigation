class Configuration<DestinationType: Destination, FromType: UIViewController> {
    typealias OnSuccessBlock = (Result<DestinationType, FromType>) -> Void
    typealias OnCompletionBlock = (Result<DestinationType, FromType>) -> Void
    typealias OnFailureBlock = (Error) -> Void
    typealias DataPassingBlock<T> = (DataPassing.Context<T>) -> Void
    typealias CachingBlock = () -> (String, Cacheable)
    
    let navigationType: NavigationType
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
    
    init(navigationType: NavigationType, toBlock: @escaping () -> DestinationType, from sourceViewController: FromType) {
        self.navigationType = navigationType
        self.toBlock = toBlock
        self.sourceViewController = sourceViewController
    }
}
