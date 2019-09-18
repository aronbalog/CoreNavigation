extension Navigation.ViewController {
    public class Builder<DestinationType: Destination> {
        let configuration: Configuration<DestinationType, UIViewController>
        private let queue: DispatchQueue

        init(configuration: Configuration<DestinationType, UIViewController>, queue: DispatchQueue) {
            self.configuration = configuration
            self.queue = queue
        }
    }
}
