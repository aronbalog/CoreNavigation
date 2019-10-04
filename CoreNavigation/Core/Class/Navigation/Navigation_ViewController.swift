extension Navigation {
    public class ViewController<BuildableType: Buildable> {
        private let queue: DispatchQueue

        init(queue: DispatchQueue) {
            self.queue = queue
        }

        @discardableResult public func viewController(for destination: BuildableType.DestinationType) -> BuildableType {
            BuildableType.init(
                configuration: Configuration(
                    directive: .none,
                    toBlock: { destination },
                    from: UIViewController.visibleViewController()
                ),
                queue: queue)
        }
    }

}
