extension Navigation.Builder.To.Present {
    @discardableResult public func modalTransitionStyle(_ block: @escaping () -> UIModalTransitionStyle) -> Self {
        queue.sync { configuration.modalTransitionStyleBlock = block }

        return self
    }

    @discardableResult public func modalTransitionStyle(_ modalTransitionStyle: UIModalTransitionStyle) -> Self {
        self.modalTransitionStyle { modalTransitionStyle }
    }
}
