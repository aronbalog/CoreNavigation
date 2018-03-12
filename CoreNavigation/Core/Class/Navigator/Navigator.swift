import Foundation

class Navigator {
    static var queue: OperationQueue = {
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()

    static func navigate<T>(with type: NavigationType, configuration: Configuration<T>) {
        let operation = NavigationOperation(block: { handler in
            switch configuration.destination {
            case .viewController(let viewController):
                switch type {
                case .push:
                    push(viewController, with: configuration, completion: {
                        handler()
                    })
                case .present:
                    present(viewController, with: configuration, completion: {
                        handler()
                    })
                }
            case .routePath(let routePath):
                ()
            case .unknown:
                ()
            }
        })
        
        queue.addOperation(operation)
    }
}
