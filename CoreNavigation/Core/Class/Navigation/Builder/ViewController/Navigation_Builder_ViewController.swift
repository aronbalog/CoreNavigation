extension Navigation.Builder {
    public class ViewController<DestinationType: Destination>: Buildable {
        public typealias FromType = UIViewController
        public let configuration: Configuration<DestinationType, UIViewController>
        public let queue: DispatchQueue

        public required init(configuration: Configuration<DestinationType, UIViewController>, queue: DispatchQueue) {
            self.configuration = configuration
            self.queue = queue
        }
    }
}
