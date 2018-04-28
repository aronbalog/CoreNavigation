import Foundation

extension UIView {
    private static let association = ObjectAssociation<KeyboardObserver>()

    var keyboardObserver: KeyboardObserver? {
        get { return UIView.association[self] }
        set { UIView.association[self] = newValue }
    }
}
