extension Navigator {
    func passData<DestinationType: Destination, FromType: UIViewController>(
        _ block: ((DataPassing.Context<Any>) -> Void)?,
        to potentialDataReceivables: [Any?],
        configuration: Configuration<DestinationType, FromType>) {
        guard let block = block else { return }
        let potentialDataReceivables = potentialDataReceivables.compactMap { $0 as? AnyDataReceivable }
        potentialDataReceivables.forEach { (dataReceivable) in
            queue.sync {
                block(DataPassing.Context<Any>(onPassData: { data in
                    self.queue.sync {
                        dataReceivable.didReceiveAnyData(data)
                        if let viewController = dataReceivable as? UIViewController {
                            self.prepareForStateRestorationIfNeeded(viewController: viewController, with: configuration, viewControllerData: data)
                        }
                    }
                }))
            }
        }
    }
}
