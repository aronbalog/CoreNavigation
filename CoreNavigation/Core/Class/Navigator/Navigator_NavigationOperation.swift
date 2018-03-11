import Foundation

extension Navigator {
    class NavigationOperation: Operation {
        let block: (@escaping () -> Void) -> Void
        
        init(block: @escaping (@escaping () -> Void) -> Void) {
            self.block = block
        }
        
        private var _executing = false {
            willSet {
                willChangeValue(forKey: "isExecuting")
            }
            didSet {
                didChangeValue(forKey: "isExecuting")
            }
        }
        
        override var isExecuting: Bool {
            return _executing
        }
        
        private var _finished = false {
            willSet {
                willChangeValue(forKey: "isFinished")
            }
            
            didSet {
                didChangeValue(forKey: "isFinished")
            }
        }
        
        override var isFinished: Bool {
            return _finished
        }
        
        func executing(_ executing: Bool) {
            _executing = executing
        }
        
        func finish(_ finished: Bool) {
            _finished = finished
        }
        
        override func main() {
            guard isCancelled == false else {
                finish(true)
                return
            }
            
            executing(true)
            block({
                self.executing(false)
                self.finish(true)
            })
        }
    }
}
