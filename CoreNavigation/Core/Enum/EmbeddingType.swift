public enum EmbeddingType {
    case navigationController
    case embeddable(Embeddable)
    
    func embeddable() -> Embeddable {
        switch self {
        case .navigationController: return NavigationControllerEmbed()
        case .embeddable(let aProtocol): return aProtocol
        }
    }
}
