extension Navigation.Builder.Segue {
    @discardableResult public func `catch`(_ block: @escaping (Error) -> Void) -> Self {
        queue.sync { configuration.onFailureBlocks.append(block) }
        
        return self
    }
}
