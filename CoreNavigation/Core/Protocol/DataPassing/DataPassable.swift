import Foundation

protocol DataPassable: class {
    associatedtype DataPassing: DataPassingAware

    var dataPassing: DataPassing { get set }

    @discardableResult func passData(_ data: Any) -> Self
}

// MARK: - Abstract data passing configuration
extension Configuration: DataPassable {
    /// Prepares data for view controller.
    ///
    /// - Parameter data: Data to pass.
    /// - Returns: Configuration instance.
    @discardableResult public func passData(_ data: Any) -> Self {
        queue.async(flags: .barrier) {
            self.dataPassing.data = data
        }

        return self
    }

    /// Prepares data for view controller.
    ///
    /// - Parameter data: Data to pass.
    /// - Returns: Configuration instance.
    @discardableResult public func withData(_ data: Any) -> Self {
        return passData(data)
    }
}

// MARK: - Data receivable view controller data passing configuration
extension Configuration where ResultableType.ToViewController: DataReceivable {
    /// Prepares data for data receiving view controller.
    ///
    /// - Parameter data: Data to pass.
    /// - Returns: Configuration instance.
    @discardableResult public func passData(_ data: ResultableType.ToViewController.DataType) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>> {
        queue.async(flags: .barrier) {
            self.dataPassing.data = data
        }

        return cast(self, to: Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>>.self)
    }

    /// Prepares data for data receiving view controller.
    ///
    /// - Parameter dataBlock: Block to pass data.
    /// - Returns: Configuration instance.
    @discardableResult public func passDataInBlock(_ dataBlock: @escaping (@escaping (ResultableType.ToViewController.DataType) -> Void) -> Void) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>> {
        queue.async(flags: .barrier) {
            self.dataPassing.dataBlock = dataBlock
        }

        return cast(self, to: Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>>.self)
    }

    /// Prepares data for data receiving view controller.
    ///
    /// - Parameter data: Data to pass.
    /// - Returns: Configuration instance.
    @discardableResult public func withData(_ data: ResultableType.ToViewController.DataType) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>> {
        return passData(data)
    }
    
    /// Prepares data for data receiving view controller.
    ///
    /// - Parameter dataBlock: Block to pass data.
    /// - Returns: Configuration instance.
    @discardableResult public func withDataInBlock(_ dataBlock: @escaping (@escaping (ResultableType.ToViewController.DataType) -> Void) -> Void) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>> {
        return passDataInBlock(dataBlock)
    }
}
