import Foundation

/// Provides navigation history logic.
public class History {
    static let shared = History()
    
    var items: [HistoryItem] = []
    
    private init() {}
    
    func add(_ historyItem: HistoryItem) {
        items.append(historyItem)
    }
    
    /// Dismisses or pops one view controller or stack of view controllers.
    ///
    /// - Parameters:
    ///   - steps: Number of steps to go back.
    ///   - animated: Boolean, `true` for animated transition, otherwise `false`.
    ///   - completion: Completion block.
    public func back(steps: Int = 1, animated: Bool = true, completion: (() -> Void)? = nil) {
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
