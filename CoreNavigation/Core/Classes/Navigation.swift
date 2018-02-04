import UIKit

public struct Navigation {
    private typealias BaseConfiguration = Configuration.Base<UIViewController, UIViewController, UIViewController>
    
    public static func present(_ configuration: @escaping (Configuration.Present) -> Void) {
        DispatchQueue.main.async {
            let _configuration = BaseConfiguration(action: .present)
            
            configuration(Configuration.Present(with: _configuration))
            
            Navigator(configuration: _configuration).execute(nil)
        }
    }
    
    public static func push(_ configuration: @escaping (Configuration.Push) -> Void) {
        DispatchQueue.main.async {
            let _configuration = BaseConfiguration(action: .push)
        
            configuration(Configuration.Push(with: _configuration))
        
            Navigator(configuration: _configuration).execute(nil)
        }
    }
    
    public static func response(_ configuration: (Configuration.Response) -> Void)  -> Response<UIViewController, UIViewController, UIViewController>? {
        let _configuration = BaseConfiguration(action: .response)
        
        configuration(Configuration.Response(with: _configuration))
        
        return Navigator(configuration: _configuration).execute(nil)
    }
}
