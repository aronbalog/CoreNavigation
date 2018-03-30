import Foundation

/// Acts as factory for embedding view controllers.
public protocol EmbeddingProtocol {
    /// Called by module asking view controller to navigate.
    ///
    /// - Parameter viewController: View controller to embed.
    /// - Returns: New view controller to navigate.
    static func embed(_ viewController: UIViewController) -> UIViewController
}
