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
    }
}
