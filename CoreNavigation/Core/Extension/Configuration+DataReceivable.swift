import Foundation

extension Configuration {
    public func pass(_ data: Any) -> Self {
        dataPassing.data = data
        
        willNavigateBlocks.append { [weak self] (viewController) in
            guard let `self` = self else { return }
            
            if let data = self.dataPassing.data {
                (viewController as? AbstractDataReceivable)?.didReceiveAbstractData(data)
            }
            
            self.events.navigationEvents.forEach({ (event) in
                if case Events.NavigationEvent.passData(let block) = event {
                    block(data)
                }
            })
            
            (self.events.passDataBlocks as? [(Any?) -> Void])?.forEach { block in
                block(data)
            }
        }
        
        return self
    }
}

extension Configuration where ResultableType.ToViewController: DataReceivable {
    @discardableResult public func pass(_ data: ResultableType.ToViewController.DataType) -> Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>> {
        dataPassing.data = data
        
        willNavigateBlocks.append { [weak self] (viewController) in
            guard let `self` = self else { return }
            
            let data = self.dataPassing.data as! ResultableType.ToViewController.DataType
            (viewController as! ResultableType.ToViewController).didReceiveData(data)
            self.events.navigationEvents.forEach({ (event) in
                if case Events.NavigationEvent.passData(let block) = event {
                    block(data)
                }
            })
            
            (self.events.passDataBlocks as? [(ResultableType.ToViewController.DataType) -> Void])?.forEach { block in
                block(data)
            }
        }
        
        return cast(self, to: Configuration<Result<ResultableType.ToViewController, ResultableType.ToViewController.DataType>>.self)
    }
}

extension Configuration.Event where ResultableType.ToViewController: DataReceivable {
    @discardableResult public func passData(_ block: @escaping (ResultableType.ToViewController.DataType) -> Void) -> Configuration {
        configuration.events.passDataBlocks.append(block)
        
        return configuration
    }
}
