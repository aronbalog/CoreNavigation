import Foundation

extension Navigator {
    static func present<T>(_ viewController: UIViewController, with configuration: Configuration<T>, completion: @escaping () -> Void)  {
        let animated = configuration.transitioning.animated
        
        DispatchQueue.main.async {
            let fromViewController = UIViewController.currentViewController
            let completionBlocks = configuration.transitioning.completionBlocks

            let viewControllerToPresent: UIViewController = {
                guard let embeddingType = configuration.embedding.embeddingType else { return viewController }
                
                switch embeddingType {
                case .embeddingProtocol(let aProtocol):
                    return aProtocol.embed(viewController)
                case .navigationController:
                    return UINavigationController(rootViewController: viewController)
                }
            }()
            
            let item = History.Item(viewController: viewControllerToPresent,
                                    navigationType: .present,
                                    configuration: configuration)
            History.shared.add(item)
            
            fromViewController?.present(viewControllerToPresent, animated: animated, completion: {
                completionBlocks.forEach { $0() }
                completion()
            })
        }
    }
}
