extension Navigation.Builder.Back {
    @discardableResult public func onComplete(_ block: @escaping (FromViewControllerType, ToViewControllerType) -> Void) -> Self {
        queue.sync {
            configuration.onCompletionBlocks.append { block($0.fromViewController, $0.toViewController as! ToViewControllerType) }
        }

        return self
    }
}
