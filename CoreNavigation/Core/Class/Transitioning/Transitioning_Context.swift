extension Transitioning {
    public class Context<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController> {
        public let fromViewController: FromViewControllerType
        public let toViewController: ToViewControllerType
        public let presentingViewController: UIViewController
        public let transitionContext: UIViewControllerContextTransitioning
        public let duration: TimeInterval
        
        init(
            fromViewController: FromViewControllerType,
            toViewController: ToViewControllerType,
            presentingViewController: UIViewController,
            transitionContext: UIViewControllerContextTransitioning,
            duration: TimeInterval
        ) {
            self.fromViewController = fromViewController
            self.toViewController = toViewController
            self.presentingViewController = presentingViewController
            self.transitionContext = transitionContext
            self.duration = duration
        }
    }
}
