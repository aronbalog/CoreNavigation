extension Navigation.Back {
    public class Builder<ViewControllerType: UIViewController> {
        let configuration: Configuration<UIViewController.Destination<UIViewController>.None, ViewControllerType>
        private let queue: DispatchQueue
        
        init(configuration: Configuration<UIViewController.Destination<UIViewController>.None, ViewControllerType>, queue: DispatchQueue) {
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
            return animated { isAnimated }
        }
        
        @discardableResult public func onComplete(_ block: @escaping (ViewControllerType) -> Void) -> Self {
            queue.sync {
                configuration.onCompletionBlocks.append { block($0.fromViewController) } 
            }
            
            return self
        }
    }
}
