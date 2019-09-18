extension Navigation {
    public class Result<DestinationType: Destination, FromType: UIViewController> {
        public let destination: DestinationType
        public let toViewController: DestinationType.ViewControllerType
        public let fromViewController: FromType

        init(destination: DestinationType, toViewController: DestinationType.ViewControllerType, fromViewController: FromType) {
            self.destination = destination
            self.toViewController = toViewController
            self.fromViewController = fromViewController
        }
    }
}
