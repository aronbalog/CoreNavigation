class Configuration<DestinationType: Destination, FromType: UIViewController> {
    typealias OnSuccessBlock = (Result<DestinationType, FromType>) -> Void
    typealias OnCompletionBlock = (Result<DestinationType, FromType>) -> Void
    typealias OnFailureBlock = (Error) -> Void
    
    let navigationType: NavigationType
    var to: DestinationType
    var sourceViewController: FromType
    var isAnimated: Bool = true
    var dataToPass: DataPassing.Strategy?
    var onSuccessBlocks: [OnSuccessBlock] = []
    var onCompletionBlocks: [OnCompletionBlock] = []
    var onFailureBlocks: [OnFailureBlock] = []
    var protections: [Protectable] = []
    var embeddable: Embeddable?
    
    init(navigationType: NavigationType, to: DestinationType, from sourceViewController: FromType) {
        self.navigationType = navigationType
        self.to = to
        self.sourceViewController = sourceViewController
    }
}
