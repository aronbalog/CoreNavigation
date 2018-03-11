import Foundation

public protocol TransitionAware: class {
    var animated: Bool { get set }
    var completionBlocks: [() -> Void] { get set }
}

public protocol Transitionable: class {
    associatedtype Transition: TransitionAware
    
    var transition: Transition { get set }
    
    @discardableResult func animated(_ animated: Bool) -> Self
    @discardableResult func completion(_ completion: @escaping () -> Void) -> Self
}

extension Transitionable {
    @discardableResult public func animated(_ animated: Bool) -> Self {
        transition.animated = animated
        
        return self
    }
    
    @discardableResult public func completion(_ completion: @escaping () -> Void) -> Self {
        transition.completionBlocks.append(completion)
        
        return self
    }

}
