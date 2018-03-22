import Foundation

extension Route where Self.Destination: UIViewController {
    func viewController(_ viewControllerBlock: @escaping (Self.Destination) -> Void) {
        let handler = RouteHandler<Self>(parameters: parameters)

        let configuration = Configuration<Result<Self.Destination, Any>>(destination: .viewControllerBlock(handler.onDestination))
        
        Navigator.getViewController(configuration: configuration, completion: viewControllerBlock)
        
        type(of: self).route(handler: handler)
    }
}

