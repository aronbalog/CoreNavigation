extension Navigation.Builder.Segue {
    @discardableResult public func passDataToViewController(_ data: Any?) -> Self {
        queue.sync { configuration.dataPassingBlock = { $0.passData(data) } }
        
        return self
    }
}
