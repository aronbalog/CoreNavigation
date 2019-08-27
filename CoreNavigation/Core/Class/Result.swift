public class Result<DestinationType: Destination, FromType: UIViewController> {
    public let toViewController: DestinationType.ViewControllerType
    public let fromViewController: FromType?
    
    init(toViewController: DestinationType.ViewControllerType, fromViewController: FromType?) {
        self.toViewController = toViewController
        self.fromViewController = fromViewController
    }
}
