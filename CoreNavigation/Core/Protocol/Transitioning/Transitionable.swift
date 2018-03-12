import Foundation

public protocol Transitionable: class {
    associatedtype Transitioning: TransitioningAware
    
    var transitioning: Transitioning { get set }
    
    @discardableResult func animated(_ animated: Bool) -> Self
    @discardableResult func completion(_ completion: @escaping () -> Void) -> Self
}

extension Transitionable {
    @discardableResult public func animated(_ animated: Bool) -> Self {
        transitioning.animated = animated
        
        return self
    }
    
    @discardableResult public func completion(_ completion: @escaping () -> Void) -> Self {
        transitioning.completionBlocks.append(completion)
        
        return self
    }

}
