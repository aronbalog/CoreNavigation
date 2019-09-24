precedencegroup OperationChaining {
    associativity: left
}
infix operator ==> : OperationChaining

@discardableResult public func ==><T: Navigation.Operation>(lhs: T, rhs: T) -> T {
    rhs.addDependency(lhs)
    return rhs
}

extension Navigation {
    public class Operation: Foundation.Operation {
        let block: (Navigation.Operation) -> Void
        unowned var presentedViewController: UIViewController?
        
        init(block: @escaping (Navigation.Operation) -> Void) {
            self.block = block
            super.init()
        }
        
        public override var isAsynchronous: Bool {
            true
        }
        
        private var _isFinished: Bool = false
        public override var isFinished: Bool {
            set {
                willChangeValue(forKey: "isFinished")
                _isFinished = newValue
                didChangeValue(forKey: "isFinished")
            }
            
            get {
                _isFinished
            }
        }
        
        private var _isExecuting: Bool = false
        public override var isExecuting: Bool {
            set {
                willChangeValue(forKey: "isExecuting")
                _isExecuting = newValue
                didChangeValue(forKey: "isExecuting")
            }
            
            get {
                _isExecuting
            }
        }
        
        func execute() {
            if isCancelled {
                isFinished = true
                return
            }
            
            unowned let unownedSelf = self
            
            block(unownedSelf)
        }
        
        public override func start() {
            isExecuting = true
            isFinished = false
            execute()
        }
        
        func finish() {
            isExecuting = false
            isFinished = true
        }
        
        public override func cancel() {
            super.cancel()
            
            isFinished = true
            isExecuting = false
        }
    }
}
