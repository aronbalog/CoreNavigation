extension Navigation.ViewController {
    public class Builder<DestinationType: Destination, FromType: UIViewController> {
        let configuration: Configuration<DestinationType, FromType>
        private let queue: DispatchQueue
        
        init(configuration: Configuration<DestinationType, FromType>, queue: DispatchQueue) {
            self.configuration = configuration
            self.queue = queue
        }  
    }
}
