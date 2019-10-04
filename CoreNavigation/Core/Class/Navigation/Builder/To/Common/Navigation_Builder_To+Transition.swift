extension Navigation.Builder.To {
    @discardableResult public func transitioningDelegate(_ transitioningDelegate: UIViewControllerTransitioningDelegate) -> Self {
        queue.sync { configuration.transitioningDelegateBlock = { transitioningDelegate } }

        return self
    }

    @discardableResult public func transitioningDelegate(_ block: @escaping () -> UIViewControllerTransitioningDelegate) -> Self {
        queue.sync { configuration.transitioningDelegateBlock = block }

        return self
    }

    @discardableResult public func transition<ToType: UIViewController>(with transitionDuration: TimeInterval, _ block: @escaping (Transitioning.Context<FromType, ToType>) -> Void) -> Self {
        queue.sync {
            configuration.transitioningDelegateBlock = {
                Transitioning.Delegate(
                    transitionDuration: transitionDuration,
                    transitionAnimation: block)
            }
        }

        return self
    }
}
