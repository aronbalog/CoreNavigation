extension Navigation.Builder.To where DestinationType: DataReceivable {
    @discardableResult public func passData(_ data: DestinationType.DataType) -> Self {
        queue.sync { configuration.dataPassingBlock = { $0.passData(data) } }

        return self
    }

    @discardableResult public func passData(_ block: @escaping (DataPassing.Context<DestinationType.DataType>) -> Void) -> Self {
        queue.sync {
            configuration.dataPassingBlock = { context in
                block(DataPassing.Context(onPassData: context.passData))
            }
        }

        return self
    }
}

extension Navigation.Builder.To where DestinationType.ViewControllerType: DataReceivable {
    @discardableResult public func passDataToViewController(_ data: DestinationType.ViewControllerType.DataType) -> Self {
        queue.sync {
            configuration.dataPassingBlock = { context in
                context.passData(data)
            }
        }

        return self
    }

    @discardableResult public func passDataToViewController(_ block: @escaping (DataPassing.Context<DestinationType.ViewControllerType.DataType>) -> Void) -> Self {
        queue.sync {
            configuration.dataPassingBlock = { context in
                block(DataPassing.Context(onPassData: context.passData))
            }
        }

        return self
    }
}

extension Navigation.Builder.To where FromType: DataReceivable {
    @discardableResult public func onReturnedData(_ block: @escaping (FromType.DataType, DestinationType.ViewControllerType) -> Void) -> Self {
        queue.sync {
            configuration.dataReturningBlocks.append { (data, viewController) in
                guard
                    let data = data as? FromType.DataType,
                    let viewController = viewController as? DestinationType.ViewControllerType
                    else { return }
                
                block(data, viewController)
            }
            
        }

        return self
    }
}
