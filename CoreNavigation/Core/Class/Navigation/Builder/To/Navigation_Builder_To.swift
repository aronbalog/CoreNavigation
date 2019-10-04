extension Navigation.Builder {
    public class To<DestinationType: Destination, FromType: UIViewController>: Buildable {
        public let configuration: Configuration<DestinationType, FromType>
        public let queue: DispatchQueue

        public required init(configuration: Configuration<DestinationType, FromType>, queue: DispatchQueue) {
            self.configuration = configuration
            self.queue = queue
        }
    }
}
