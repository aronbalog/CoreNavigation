class KeyboardObserver {
    enum Event {
        case keyboardWillShow
        case keyboardWillHide
        case keyboardDidShow
        case keyboardDidHide
    }

    struct KeyboardInfo {
        let beginFrame: CGRect
        let endFrame: CGRect
        let animationDuration: TimeInterval
        let animationOptions: UIView.AnimationOptions
    }

    private class Handler {
        let event: Event
        let action: (KeyboardInfo) -> Void

        init(event: Event, action: @escaping (KeyboardInfo) -> Void) {
            self.event = event
            self.action = action
        }
    }

    private var handlers: [Handler] = []

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHideNotification(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @discardableResult func keyboardWillShow(_ callback: @escaping (KeyboardInfo) -> Void) -> Self {
        handlers.append(Handler(event: .keyboardWillShow, action: callback))

        return self
    }

    @discardableResult func keyboardDidShow(_ callback: @escaping (KeyboardInfo) -> Void) -> Self {
        handlers.append(Handler(event: .keyboardDidShow, action: callback))

        return self
    }

    @discardableResult func keyboardWillHide(_ callback: @escaping (KeyboardInfo) -> Void) -> Self {
        handlers.append(Handler(event: .keyboardWillHide, action: callback))

        return self
    }

    @discardableResult func keyboardDidHide(_ callback: @escaping (KeyboardInfo) -> Void) -> Self {
        handlers.append(Handler(event: .keyboardDidHide, action: callback))

        return self
    }

    @objc func keyboardWillShowNotification(_ notification: NSNotification) {
        guard let info = keyboardInfo(for: notification) else { return }

        notify(with: info, event: .keyboardWillShow)
    }

    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        guard let info = keyboardInfo(for: notification) else { return }

        notify(with: info, event: .keyboardWillHide)
    }

    @objc func keyboardDidShowNotification(_ notification: NSNotification) {
        guard let info = keyboardInfo(for: notification) else { return }

        notify(with: info, event: .keyboardDidShow)
    }

    @objc func keyboardDidHideNotification(_ notification: NSNotification) {
        guard let info = keyboardInfo(for: notification) else { return }

        notify(with: info, event: .keyboardDidHide)
    }

    private func notify(with keyboardInfo: KeyboardInfo, event: Event) {
        handlers.forEach { (handler) in
            if handler.event == event {
                handler.action(keyboardInfo)
            }
        }
    }

    private func keyboardInfo(for notification: NSNotification) -> KeyboardInfo? {
        guard let userInfo = notification.userInfo else { return nil }

        let beginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let animationDuration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationOptions: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

        let keyboardInfo = KeyboardInfo(beginFrame: beginFrame!,
                                        endFrame: endFrame!,
                                        animationDuration: animationDuration,
                                        animationOptions: animationOptions)

        return keyboardInfo
    }
}
