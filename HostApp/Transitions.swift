import UIKit
import CoreNavigation

struct AnimationHelper {
    static func yRotation(_ angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransform(for containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
    }
}

typealias Transition<FromViewController: UIViewController, ToViewController: UIViewController> = (Transitioning.Context<FromViewController, ToViewController>) -> Void

let viewController_ViewController2: Transition<ViewController, UIViewController> = { (context) in
    let toVC = context.toViewController
    let fromVC = context.fromViewController
    let containerView = context.transitionContext.containerView
    let finalFrame = context.transitionContext.finalFrame(for: toVC)
    let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)!
    
    snapshot.frame = fromVC.button.frame
    snapshot.layer.cornerRadius = 10.0
    snapshot.layer.masksToBounds = true
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshot)
    toVC.view.isHidden = true
    
    AnimationHelper.perspectiveTransform(for: containerView)
    snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
    
    UIView.animateKeyframes(
        withDuration: context.duration,
        delay: 0,
        options: .calculationModeCubic,
        animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                snapshot.layer.transform = AnimationHelper.yRotation(0.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                snapshot.frame = finalFrame
                snapshot.layer.cornerRadius = 0
            }
    },
        completion: { _ in
            toVC.view.isHidden = false
            snapshot.removeFromSuperview()
            fromVC.view.layer.transform = CATransform3DIdentity
            context.transitionContext.completeTransition(!context.transitionContext.transitionWasCancelled)
    })
}
