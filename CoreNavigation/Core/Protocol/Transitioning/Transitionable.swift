import Foundation

protocol Transitionable: class {
    associatedtype Transitioning: TransitioningAware
    
    var transitioning: Transitioning { get set }
    
    @discardableResult func animated(_ animated: Bool) -> Self
    @discardableResult func completion(_ completion: @escaping () -> Void) -> Self
    @discardableResult func transitioningDelegate(_ transitioningDelegate: UIViewControllerTransitioningDelegate) -> Self
}

extension Configuration: Transitionable {
    /// Animates navigation.
    ///
    /// - Parameter animated: Boolean stating whether navigation is transitioned with animation.
    /// - Returns: Configuration instance.
    @discardableResult public func animated(_ animated: Bool) -> Self {
        transitioning.animated = animated
        
        return self
    }
    
    /// Observes navigation transitioning completion.
    ///
    /// - Parameter completion: Completion block called after navigation transitioning.
    /// - Returns: Configuration instance.
    @discardableResult public func completion(_ completion: @escaping () -> Void) -> Self {
        transitioning.completionBlocks.append(completion)
        
        return self
    }

    /// Sets UIViewControllerTransitioningDelegate to destination view controller.
    ///
    /// - Parameter transitioningDelegate: UIViewControllerTransitioningDelegate object.
    /// - Returns: Configuration instance.
    @discardableResult public func transitioningDelegate(_ transitioningDelegate: UIViewControllerTransitioningDelegate) -> Self {
        transitioning.viewControllerTransitioningDelegate = transitioningDelegate
        
        return self
    }
}
