extension Navigation.To {
    public class Builder<DestinationType: Destination, FromType: UIViewController> {
        let configuration: Configuration<DestinationType, FromType>
        private let queue: DispatchQueue

        init(configuration: Configuration<DestinationType, FromType>, queue: DispatchQueue) {
            self.configuration = configuration
            self.queue = queue
        }

        @discardableResult public func animated(_ block: @escaping () -> Bool) -> Self {
            queue.sync {
                configuration.isAnimatedBlock = block
            }

            return self
        }

        @discardableResult public func animated(_ isAnimated: Bool) -> Self {
            animated { isAnimated }
        }

        @discardableResult public func transitioningDelegate(_ transitioningDelegate: UIViewControllerTransitioningDelegate) -> Self {
            queue.sync {
                configuration.transitioningDelegateBlock = { transitioningDelegate }
            }

            return self
        }

        @discardableResult public func transitioningDelegate(_ block: @escaping () -> UIViewControllerTransitioningDelegate) -> Self {
            queue.sync {
                configuration.transitioningDelegateBlock = block
            }

            return self
        }

        @discardableResult public func transition<ToType: UIViewController>(with transitionDuration: TimeInterval, _ block: @escaping (Transitioning.Context<FromType, ToType>) -> Void) -> Self {
            queue.sync {
                configuration.transitioningDelegateBlock = { Transitioning.Delegate(transitionDuration: transitionDuration, transitionAnimation: block) }
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

        @discardableResult public func embed(inside embeddingType: Embedding.EmbeddingType) -> Self {
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

        @discardableResult public func cache(cacheIdentifier: String, cacheable: Cacheable) -> Self {
            queue.sync {
                configuration.cachingBlock = { (cacheIdentifier, cacheable) }
            }

            return self
        }

        @discardableResult public func cache(cacheIdentifier: String, cachingType: Caching.CachingType) -> Self {
            queue.sync {
                configuration.cachingBlock = { (cacheIdentifier, Caching.Builder(cachingType: cachingType)) }
            }

            return self
        }

        @discardableResult public func cache(cacheIdentifier: String, _ block: @escaping (Caching.Context) -> Void) -> Self {
            queue.sync {
                configuration.cachingBlock = { (cacheIdentifier, Caching.Builder(cachingType: .block(block))) }
            }

            return self
        }
        
        @discardableResult public func stateRestorable(with identifier: String, until expirationDate: Date = Date.distantFuture) -> Self {
            queue.sync {
                configuration.stateRestorationBlock = { (identifier, expirationDate) }
            }
            
            return self
        }
        
        @discardableResult public func delay(_ block: @escaping () -> TimeInterval) -> Self {
            queue.sync {
                configuration.delayBlock = block
            }
            
            return self
        }
        
        @discardableResult public func delay(_ seconds: TimeInterval) -> Self {
            delay { seconds }
        }

        @discardableResult public func `catch`(_ block: @escaping (Error) -> Void) -> Self {
            queue.sync {
                configuration.onFailureBlocks.append(block)
            }

            return self
        }

        @discardableResult public func onSuccess(_ block: @escaping (Navigation.Result<DestinationType, FromType>) -> Void) -> Self {
            queue.sync {
                configuration.onSuccessBlocks.append(block)
            }

            return self
        }

        @discardableResult public func onComplete(_ block: @escaping (Navigation.Result<DestinationType, FromType>) -> Void) -> Self {
            queue.sync {
                configuration.onCompletionBlocks.append(block)
            }

            return self
        }

        @discardableResult public func onViewControllerEvents(_ events: UIViewController.Event<DestinationType.ViewControllerType>...) -> Self {
            queue.sync {
                configuration.viewControllerEventBlocks.append { events }
            }

            return self
        }

        @discardableResult public func onViewControllerEvents(_ block: @escaping (UIViewController.Event<DestinationType.ViewControllerType>.Builder) -> UIViewController.Event<DestinationType.ViewControllerType>.Builder) -> Self {
            queue.sync {
                configuration.viewControllerEventBlocks.append { block(UIViewController.Event<DestinationType.ViewControllerType>.Builder(queue: self.queue)).events }
            }

            return self
        }
    }
}

extension Navigation.To.Builder where DestinationType: DataReceivable {
    @discardableResult public func passData(_ data: DestinationType.DataType) -> Self {
        queue.sync {
            configuration.dataPassingBlock = { context in
                context.passData(data)
            }
        }

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

extension Navigation.To.Builder where DestinationType.ViewControllerType: DataReceivable {
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

extension Navigation.To.Builder where DestinationType: Routing.Destination {
    @discardableResult public func cache(with cacheable: Cacheable) -> Self {
        cache(cacheIdentifier: configuration.destination.route.uri, cacheable: cacheable)
    }

    @discardableResult public func cache(with cachingType: Caching.CachingType) -> Self {
        cache(with: Caching.Builder(cachingType: cachingType))
    }

    @discardableResult public func cache(_ block: @escaping (Caching.Context) -> Void) -> Self {
        cache(with: Caching.Builder(cachingType: .block(block)))
    }
}
