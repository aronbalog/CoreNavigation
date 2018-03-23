import Foundation

extension Navigator {
    class NavigationOperation: Operation {
        private let block: (@escaping () -> Void) -> Void
        
        fileprivate var _finished = false {
            willSet {
                willChangeValue(forKey: "isFinished")
            }
            
            didSet {
                didChangeValue(forKey: "isFinished")
            }
        }
        
        fileprivate var _executing = false {
            willSet {
                willChangeValue(forKey: "isExecuting")
            }
            didSet {
                didChangeValue(forKey: "isExecuting")
            }
        }
        
        init(block: @escaping (@escaping () -> Void) -> Void) {
            self.block = block
        }
        
        override func main() {
            executing(true)
            block({
                self.executing(false)
                self.finish(true)
            })
        }
    }
}

extension Navigator.NavigationOperation {
    override var isExecuting: Bool {
        return _executing
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }

    override var isFinished: Bool {
        return _finished
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
}
