extension Navigation.Builder.To {
    @discardableResult public func onViewControllerEvents(_ events: UIViewController.Event<DestinationType.ViewControllerType>...) -> Self {
        queue.sync { configuration.viewControllerEventBlocks.append { events } }

        return self
    }

    @discardableResult public func onViewControllerEvents(_ block: @escaping (UIViewController.Event<DestinationType.ViewControllerType>.Builder) -> UIViewController.Event<DestinationType.ViewControllerType>.Builder) -> Self {
        queue.sync {
            configuration.viewControllerEventBlocks.append { block(UIViewController.Event<DestinationType.ViewControllerType>.Builder(queue: self.queue)).events
            }
        }

        return self
    }
}
