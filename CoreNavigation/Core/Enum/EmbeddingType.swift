import Foundation

/// Defines embedding behaviour.
///
/// - navigationController: Embeds destination view controller in navigation controller.
/// - embeddingProtocol: Embeds destination view controller with behaviour defined in `EmbeddingProtocol` type.
public enum EmbeddingType {
    /// Embeds destination view controller in navigation controller.
    case navigationController
    /// Embeds destination view controller with behaviour defined in `EmbeddingProtocol` type.
    case embeddingProtocol(EmbeddingProtocol.Type)
}
