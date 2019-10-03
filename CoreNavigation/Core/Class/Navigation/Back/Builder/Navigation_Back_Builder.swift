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
        
        @discardableResult public func passDataToViewController<ViewControllerType: UIViewController & DataReceivable>(ofType viewControllerType: ViewControllerType.Type, data: ViewControllerType.DataType) -> Self {
            queue.sync {
                let block: (ViewControllerType.Type, (DataPassing.Context<Any?>) -> Void) = (viewControllerType, { context in
                    context.passData(data)
                })
                configuration.backDataPassingElements.append(block)
            }

            return self
        }

        @discardableResult public func passDataToViewController<ViewControllerType: UIViewController & DataReceivable>(ofType viewControllerType: ViewControllerType.Type, _ block: @escaping (DataPassing.Context<ViewControllerType.DataType>) -> Void) -> Self {
            queue.sync {
                let block: (ViewControllerType.Type, (DataPassing.Context<Any?>) -> Void) = (viewControllerType, { context in
                    block(DataPassing.Context(onPassData: context.passData))
                })
                configuration.backDataPassingElements.append(block)
            }

            return self
        }
        
        @discardableResult public func passDataToViewController(_ data: Any?) -> Self {
            queue.sync {
                let block: (UIViewController.Type, (DataPassing.Context<Any?>) -> Void) = (UIViewController.self, { context in
                    context.passData(data)
                })
                configuration.backDataPassingElements = [block]
            }

            return self
        }

        @discardableResult public func passDataToViewController(_ block: @escaping (DataPassing.Context<Any?>) -> Void) -> Self {
            queue.sync {
                let block: (UIViewController.Type, (DataPassing.Context<Any?>) -> Void) = (UIViewController.self, { context in
                    block(DataPassing.Context(onPassData: context.passData))
                })
                configuration.backDataPassingElements = [block]
            }

            return self
        }
    }
}
