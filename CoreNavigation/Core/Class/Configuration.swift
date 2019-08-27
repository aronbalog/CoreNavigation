class Configuration<DestinationType: Destination, FromType: UIViewController> {
    typealias OnSuccessBlock = (Result<DestinationType, FromType>) -> Void
    typealias OnCompletionBlock = (Result<DestinationType, FromType>) -> Void
    typealias OnFailureBlock = (Error) -> Void
    typealias DataPassingBlock<T> = (DataPassing.Context<T>) -> Void
    
    let navigationType: NavigationType
    var to: () -> DestinationType
    var sourceViewController: FromType
    var isAnimated: () -> Bool = { true }
    var dataPassingBlock: DataPassingBlock<Any>?
    var onSuccessBlocks: [OnSuccessBlock] = []
    var onCompletionBlocks: [OnCompletionBlock] = []
    var onFailureBlocks: [OnFailureBlock] = []
    var protections: [Protectable] = []
    var embeddable: Embeddable?
    
    init(navigationType: NavigationType, to: @escaping () -> DestinationType, from sourceViewController: FromType) {
        self.navigationType = navigationType
        self.to = to
        self.sourceViewController = sourceViewController
    }
}
