extension Navigation.Builder.Segue {
    @discardableResult public func onViewControllerEvents(_ events: UIViewController.Event<UIViewController>...) -> Self {
        queue.sync { configuration.viewControllerEventBlocks.append { events } }
        
        return self
    }
    
    @discardableResult public func onViewControllerEvents(_ block: @escaping (UIViewController.Event<UIViewController>.Builder) -> UIViewController.Event<UIViewController>.Builder) -> Self {
        queue.sync {
            configuration.viewControllerEventBlocks.append { block(UIViewController.Event<UIViewController>.Builder(queue: self.queue)).events }
        }
        
        return self
    }
}
