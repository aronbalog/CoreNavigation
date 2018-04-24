import Foundation

protocol KeyboardObservable {
    @discardableResult func trackKeyboard(with keyboardTrackingMode: KeyboardTrackingMode) -> Self
}

extension Configuration: KeyboardObservable {
    /// Tracks keyboard.
    ///
    /// - Parameter keyboardTrackingMode: Keyboard tracking behaviour.
    /// - Returns: Configuration instance.
    @discardableResult public func trackKeyboard(with keyboardTrackingMode: KeyboardTrackingMode) -> Self {
        switch keyboardTrackingMode {
        case .rise:
            guard let window = windowObject.window else { return self }
            
            rise(view: window)
        case .shrink:
            queue.async(flags: .barrier) {
                self.willNavigateBlocks.append({ (viewController, _) in
                    shrink(view: viewController.view)
                })
            }
        case .default:
            ()
        }

        return self
    }
}

private func rise(view: UIView) {
    let observer = KeyboardObserver()
    
    view.keyboardObserver = observer

    let initialFrame = view.frame
    
    observer
        .keyboardWillShow { [weak view] (info) in
            guard let view = view else { return }
            
            var frame = initialFrame
            frame.origin.y = initialFrame.origin.y - info.endFrame.height
            
            UIView.animate(withDuration: info.animationDuration, delay: 0, options: info.animationOptions, animations: { [weak view] in
                guard let view = view else { return }
                
                view.frame = frame
            }, completion: { (_) in
                
            })
        }
        .keyboardWillHide { [weak view] (info) in
            guard let view = view else { return }
            
            UIView.animate(withDuration: info.animationDuration, delay: 0, options: info.animationOptions, animations: { [weak view] in
                guard let view = view else { return }
                
                view.frame = initialFrame
            }, completion: { (_) in
                
            })
        }
}

private func shrink(view: UIView) {
    let observer = KeyboardObserver()
    
    view.keyboardObserver = observer
    
    let initialFrame = view.frame
    
    observer
        .keyboardWillShow { [weak view] (info) in
            guard let view = view else { return }
            
            var frame = initialFrame
            frame.size.height = initialFrame.height - info.endFrame.height
            
            UIView.animate(withDuration: info.animationDuration, delay: 0, options: info.animationOptions, animations: { [weak view] in
                guard let view = view else { return }
                
                view.frame = frame
                }, completion: { (_) in
                    
            })
        }
        .keyboardWillHide { [weak view] (info) in
            guard let view = view else { return }
            
            UIView.animate(withDuration: info.animationDuration, delay: 0, options: info.animationOptions, animations: { [weak view] in
                guard let view = view else { return }
                
                view.frame = initialFrame
                }, completion: { (_) in
                    
            })
        }
}
