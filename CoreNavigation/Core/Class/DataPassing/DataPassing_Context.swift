extension DataPassing {
    public class Context<DataType> {
        let onPassData: (DataType) -> Void
        
        init(onPassData: @escaping (DataType) -> Void) {
            self.onPassData = onPassData
        }
        
        public func passData(_ data: DataType) {
            onPassData(data)
        }
    }
}
