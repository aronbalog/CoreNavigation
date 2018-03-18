import Foundation

public class History {
    static let shared = History()
    
    var items: [HistoryItem] = []
    
    private init() {}
    
    func add(_ historyItem: HistoryItem) {
        items.append(historyItem)
    }
    
    public func back(animated: Bool = true, completion: (() -> Void)? = nil, steps: Int = 1) {
        var index = items.count - steps - 1
        
        if index < 0 {
            index = 0
        }
        
        guard items.count > index else {
            return
        }
        
        let item = items.remove(at: index)
        items.removeSubrange(index..<items.count)
        
        item.go(.back(steps: steps), animated: animated, completion: completion)
    }
}
