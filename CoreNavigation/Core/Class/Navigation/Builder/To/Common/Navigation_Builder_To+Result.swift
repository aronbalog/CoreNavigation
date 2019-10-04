extension Navigation.Builder.To {
    @discardableResult public func `catch`(_ block: @escaping (Error) -> Void) -> Self {
        queue.sync { configuration.onFailureBlocks.append(block) }

        return self
    }

    @discardableResult public func onSuccess(_ block: @escaping (Navigation.Result<DestinationType, FromType>) -> Void) -> Self {
        queue.sync { configuration.onSuccessBlocks.append(block) }

        return self
    }

    @discardableResult public func onComplete(_ block: @escaping (Navigation.Result<DestinationType, FromType>) -> Void) -> Self {
        queue.sync { configuration.onCompletionBlocks.append(block) }

        return self
    }
}
