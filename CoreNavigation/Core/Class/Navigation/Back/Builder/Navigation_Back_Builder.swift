extension Navigation.Back {
    public class Builder<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController> {
        let configuration: Configuration<UIViewController.Destination<UIViewController>.None, FromViewControllerType>
        private let queue: DispatchQueue

        init(configuration: Configuration<UIViewController.Destination<UIViewController>.None, FromViewControllerType>, queue: DispatchQueue) {
            self.configuration = configuration
            self.queue = queue
        }

        @discardableResult public func animated(_ block: @escaping () -> Bool) -> Self {
            queue.sync {
                configuration.isAnimatedBlock = block
            }

            return self
        }

        @discardableResult public func animated(_ isAnimated: Bool) -> Self {
            animated { isAnimated }
        }

        @discardableResult public func delay(_ block: @escaping () -> TimeInterval) -> Self {
            queue.sync {
                configuration.delayBlock = block
            }
            
            return self
        }
        
        @discardableResult public func delay(_ seconds: TimeInterval) -> Self {
            delay { seconds }
        }
        
        @discardableResult public func onComplete(_ block: @escaping (FromViewControllerType, ToViewControllerType) -> Void) -> Self {
            queue.sync {
                configuration.onCompletionBlocks.append { block($0.fromViewController, $0.toViewController as! ToViewControllerType) }
            }

            return self
        }
    }
}
