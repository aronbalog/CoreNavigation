extension Navigation.Segue {
    public class Builder<FromViewControllerType: UIViewController> {
        let configuration: Configuration<UIViewController.Destination<UIViewController>.None, FromViewControllerType>
        private let queue: DispatchQueue
        
        init(
            configuration: Configuration<UIViewController.Destination<UIViewController>.None, FromViewControllerType>,
            queue: DispatchQueue
        ) {
            self.configuration = configuration
            self.queue = queue
        }
        
        @discardableResult public func protect(with protections: Protectable...) -> Self {
            queue.sync {
                configuration.protections.append(contentsOf: protections)
            }
            
            return self
        }
        
        @discardableResult public func protect(_ block: @escaping (Protection.Context) -> Void) -> Self {
            queue.sync {
                configuration.protections.append(Protection.Builder(block: block))
            }
            
            return self
        }
        
        @discardableResult public func `catch`(_ block: @escaping (Error) -> Void) -> Self {
            queue.sync {
                configuration.onFailureBlocks.append(block)
            }
            
            return self
        }
        
        @discardableResult public func prepare(_ block: @escaping (_ segue: UIStoryboardSegue, _ sender: Any?) -> Void) -> Self {
            queue.sync {
                configuration.prepareForSegueBlock = block
            }
            
            return self
        }
        
        @discardableResult public func passDataToViewController(_ data: Any?) -> Self {
            queue.sync {
                configuration.dataPassingBlock = { $0.passData(data) }
            }
            
            return self
        }
        
        @discardableResult public func stateRestorable(with identifier: String, until expirationDate: Date = Date.distantFuture) -> Self {
            queue.sync {
                configuration.stateRestorationBlock = { (identifier, expirationDate) }
            }
            
            return self
        }
        
        @discardableResult public func delay(_ block: @escaping () -> TimeInterval) -> Self {
            queue.sync {
                configuration.delayBlock = block
            }
            
            return self
        }
        
        @discardableResult public func delay(_ seconds: TimeInterval) -> Self {
            return delay { seconds }
        }
        
        @discardableResult public func onViewControllerEvents(_ events: UIViewController.Event<UIViewController>...) -> Self {
            queue.sync {
                configuration.viewControllerEventBlocks.append { events }
            }
            
            return self
        }
        
        @discardableResult public func onViewControllerEvents(_ block: @escaping (UIViewController.Event<UIViewController>.Builder) -> UIViewController.Event<UIViewController>.Builder) -> Self {
            queue.sync {
                configuration.viewControllerEventBlocks.append { block(UIViewController.Event<UIViewController>.Builder(queue: self.queue)).events }
            }
            
            return self
        }
    }
}
