import CoreNavigation
import SafariServices

struct URLDestination: Destination {
    typealias ViewControllerType = SFSafariViewController
    
    let url: URL
    
    func resolve(with resolver: Resolver<URLDestination>) {
        let viewController = SFSafariViewController(url: url)
        resolver.complete(viewController: viewController)
    }
}



