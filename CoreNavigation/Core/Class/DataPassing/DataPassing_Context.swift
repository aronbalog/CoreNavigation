extension DataPassing {
    public class Context<T> {
        let onPassData: (T) -> Void
        
        init(onPassData: @escaping (T) -> Void) {
            self.onPassData = onPassData
        }
        
        public func passData(_ data: T) {
            onPassData(data)
        }
    }
}
