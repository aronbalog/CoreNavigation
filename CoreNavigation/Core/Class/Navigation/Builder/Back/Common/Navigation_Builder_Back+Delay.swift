extension Navigation.Builder.Back {
    @discardableResult public func delay(_ block: @escaping () -> TimeInterval) -> Self {
        queue.sync { configuration.delayBlock = block }
        
        return self
    }
    
    @discardableResult public func delay(_ seconds: TimeInterval) -> Self {
        delay { seconds }
    }
}
