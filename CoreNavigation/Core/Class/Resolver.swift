public class Resolver<DestinationType: Destination> {
    let onCompleteBlock: (DestinationType.ViewControllerType) -> Void
    let onCancelBlock: (Error?) -> Void

    init(onCompleteBlock: @escaping (DestinationType.ViewControllerType) -> Void, onCancelBlock: @escaping (Error?) -> Void) {
        self.onCompleteBlock = onCompleteBlock
        self.onCancelBlock = onCancelBlock
    }
    
    public func complete(viewController: DestinationType.ViewControllerType) {
        self.onCompleteBlock(viewController)
    }
    
    public func cancel(with error: Error) {
        self.onCancelBlock(error)
    }
    
    public func cancel() {
        self.onCancelBlock(nil)
    }
}
