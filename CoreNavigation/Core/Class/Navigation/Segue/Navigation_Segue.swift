extension Navigation {
    public class Segue {
        private let queue: DispatchQueue

        init(queue: DispatchQueue) {
            self.queue = queue
        }

        public func segue<FromViewControllerType: UIViewController>(
            identifier: String,
            from sourceViewController: FromViewControllerType = UIViewController.visibleViewController()
        ) -> Navigation.Segue.Builder<FromViewControllerType> {
            Segue.Builder(
                configuration: Configuration(
                    directive: .direction(.segue(identifier)),
                    toBlock: { UIViewController.Destination<UIViewController>.None() },
                    from: sourceViewController),
                queue: queue)
        }
    }
}
