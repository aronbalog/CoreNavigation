import Foundation

protocol StateRestorable: class {
    associatedtype StateRestoration: StateRestorationAware

    var stateRestoration: StateRestoration { get set }

    @discardableResult func stateRestorable() -> Self
    @discardableResult func stateRestorable(identifier: String) -> Self
    @discardableResult func stateRestorable(identifier: String, class: UIViewControllerRestoration.Type) -> Self
}

// MARK: - State restoration configuration
extension Configuration: StateRestorable {
    /// Makes destination state restorable.
    ///
    /// - Returns: Configuration instance.
    @discardableResult public func stateRestorable() -> Self {
        queue.async(flags: .barrier) {
            self.stateRestoration.option = .automatically
        }

        return self
    }

    /// Makes destination state restorable.
    ///
    /// - Parameter identifier: Restoration identifier.
    /// - Returns: Configuration instance.
    @discardableResult public func stateRestorable(identifier: String) -> Self {
        queue.async(flags: .barrier) {
            self.stateRestoration.option = .automaticallyWithIdentifier(restorationIdentifier: identifier)
        }

        return self
    }

    /// Makes destination state restorable.
    ///
    /// - Parameters:
    ///   - identifier: Restoration identifier.
    ///   - class: Restoration class
    /// - Returns: Configuration instance.
    @discardableResult public func stateRestorable(identifier: String, class: UIViewControllerRestoration.Type) -> Self {
        queue.async(flags: .barrier) {
            self.stateRestoration.option = .manually(restorationIdentifier: identifier, restorationClass: `class`)
        }

        return self
    }

}
