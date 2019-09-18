extension DataPassing {
    /// Data passing context. Use it to pass data.
    public class Context<DataType> {
        let onPassData: (DataType) -> Void
        
        init(onPassData: @escaping (DataType) -> Void) {
            self.onPassData = onPassData
        }
        
        /// Passes data.
        ///
        /// - Parameter data: Data to pass
        public func passData(_ data: DataType) {
            onPassData(data)
        }
    }
}
