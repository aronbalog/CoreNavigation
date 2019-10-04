extension Navigation.Builder.Back {
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
