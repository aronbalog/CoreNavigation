import Foundation

protocol DataPassable: class {
    associatedtype DataPassing: DataPassingAware
    
    var dataPassing: DataPassing { get set }
    
    @discardableResult func passData(_ data: Any?) -> Self
}

// MARK: - Abstract data passing configuration
extension Configuration: DataPassable {
    /// Prepares data for view controller.
    ///
    /// - Parameter data: Data to pass.
    /// - Returns: Configuration instance.
    @discardableResult public func passData(_ data: Any?) -> Self {
        queue.async(flags: .barrier) {
            self.dataPassing.data = data

            self.willNavigateBlocks.append { [weak self] (viewController, data) in
                guard let `self` = self else { return }
                guard let viewController = viewController as? DataReceiving else { return }
                guard let data = self.dataPassing.data else { return }
                
                viewController.didReceiveAbstractData(data)
                
                self.events.navigationEvents.forEach({ (event) in
                    if case Events.NavigationEvent.passData(let block) = event {
                        guard let data = data as? ResultableType.DataType else { return }
                        block(data)
                    }
                })
                
                (self.events.passDataBlocks as? [(Any?) -> Void])?.forEach { block in
                    block(data)
                }
            }
        }
        
        return self
    }
}

// MARK: - Data receiving view controller data passing configuration
extension Configuration where ResultableType.ToViewController: DataReceivingViewController {
    /// Prepares data for data receiving view controller.
    ///
    /// - Parameter data: Data to pass.
    /// - Returns: Configuration instance.
    @discardableResult public func passData(_ data: ResultableType.ToViewController.DataType?) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>> {
        queue.async(flags: .barrier) {
            self.dataPassing.data = data

            self.willNavigateBlocks.append { [weak self] (viewController, data) in
                guard let `self` = self else { return }
                guard let data = data as? ResultableType.ToViewController.DataType else { return }
                guard let viewController = viewController as? ResultableType.ToViewController else { return }
                
                viewController.didReceiveData(data)
                
                self.events.navigationEvents.forEach({ (event) in
                    if case Events.NavigationEvent.passData(let block) = event {
                        guard let data = data as? ResultableType.DataType else { return }
                        
                        block(data)
                    }
                })
                
                (self.events.passDataBlocks as? [(ResultableType.ToViewController.DataType) -> Void])?.forEach { block in
                    block(data)
                }
            }
        }
        
        return cast(self, to: Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>>.self)
    }
}
