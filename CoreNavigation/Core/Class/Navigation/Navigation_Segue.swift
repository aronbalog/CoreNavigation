extension Navigation {
    public class Segue<BuildableType: Buildable> {
        private let queue: DispatchQueue

        init(queue: DispatchQueue) {
            self.queue = queue
        }

        public func segue<FromViewControllerType: UIViewController>(
            identifier: String,
            from sourceViewController: FromViewControllerType = UIViewController.visibleViewController()
        ) -> BuildableType where BuildableType.DestinationType == UIViewController.Destination<UIViewController>.None, BuildableType.FromType == FromViewControllerType {
            BuildableType.init(
                configuration: Configuration(
                    directive: .direction(.segue(identifier)),
                    toBlock: { UIViewController.Destination<UIViewController>.None() },
                    from: sourceViewController),
                queue: queue)
        }
    }
}
