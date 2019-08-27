class Configuration<DestinationType: Destination, FromType: UIViewController> {
    typealias OnSuccessBlock = (Result<DestinationType, FromType>) -> Void
    typealias OnFailureBlock = (Error) -> Void

    let navigationType: NavigationType
    var to: DestinationType?
    var fromViewController: UIViewController? = UIViewController.visibleViewController(in: UIApplication.shared.keyWindow)
    var isAnimated: Bool = true
    var dataToPass: Any?
    var onSuccessBlocks: [OnSuccessBlock] = []
    var onFailureBlocks: [OnFailureBlock] = []
    var protection: Protectable?
    var embeddable: Embeddable?
    
    init(navigationType: NavigationType) {
        self.navigationType = navigationType
    }
}
