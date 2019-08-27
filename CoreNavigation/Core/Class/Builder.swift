public class Builder<DestinationType: Destination, FromType: UIViewController> {
    let configuration: Configuration<DestinationType, FromType>
    private let queue: DispatchQueue
    
    init(configuration: Configuration<DestinationType, FromType>, queue: DispatchQueue) {
        self.configuration = configuration
        self.queue = queue
    }

    @discardableResult public func animated(_ isAnimated: Bool) -> Self {
        queue.sync {
            configuration.isAnimated = isAnimated
        }
        
        return self
    }
    
    @discardableResult public func protect(with protections: Protectable...) -> Self {
        queue.sync {
            configuration.protections.append(contentsOf: protections)
        }
        
        return self
    }
    
    @discardableResult public func protect(_ block: @escaping (Protection.Context) -> Void) -> Self {
        queue.sync {
            configuration.protections.append(Protection.Builder(block: block))
        }
        
        return self
    }
    
    @discardableResult public func embed(with embeddingType: EmbeddingType) -> Self {
        queue.sync {
            configuration.embeddable = embeddingType.embeddable()
        }
        
        return self
    }
    
    @discardableResult public func embed(_ block: @escaping (Embedding.Context) -> Void) -> Self {
        queue.sync {
            configuration.embeddable = Embedding.Builder(block: block)
        }
        
        return self
    }

    @discardableResult public func onFailure(_ block: @escaping (Error) -> Void) -> Self {
        queue.sync {
            configuration.onFailureBlocks.append(block)
        }
        
        return self
    }
    
    @discardableResult public func onSuccess(_ block: @escaping (Result<DestinationType, FromType>) -> Void) -> Self {
        queue.sync {
            configuration.onSuccessBlocks.append(block)
        }
        
        return self
    }
    
    @discardableResult public func onComplete(_ block: @escaping (Result<DestinationType, FromType>) -> Void) -> Self {
        queue.sync {
            configuration.onCompletionBlocks.append(block)
        }
        
        return self
    }
}

extension Builder where DestinationType: DataReceivable {
    @discardableResult public func passData(_ data: DestinationType.DataType) -> Self {
        queue.sync {
            configuration.dataToPass = .sync(data)
        }
        
        return self
    }
    
    @discardableResult public func passData(_ block: @escaping (DataPassing.Context<DestinationType.DataType>) -> Void) -> Self {
        queue.sync {
            configuration.dataToPass = DataPassing.Strategy.async({ context in
                block(DataPassing.Context(onPassData: context.passData))
            })
        }
        
        return self
    }
}

extension Builder where DestinationType.ViewControllerType: DataReceivable {
    @discardableResult public func passData(_ data: DestinationType.ViewControllerType.DataType) -> Self {
        queue.sync {
            configuration.dataToPass = .sync(data)
        }
        
        return self
    }
    
    @discardableResult public func passData(_ block: @escaping (DataPassing.Context<DestinationType.ViewControllerType.DataType>) -> Void) -> Self {
        queue.sync {
            configuration.dataToPass = DataPassing.Strategy.async({ context in
                block(DataPassing.Context(onPassData: context.passData))
            })
        }
        
        return self
    }
}
