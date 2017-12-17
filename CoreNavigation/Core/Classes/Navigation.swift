import UIKit

public struct Navigation {
    private typealias BaseConfiguration = Configuration.Base<UIViewController, UIViewController, UIViewController>
    
    public static func present(_ configuration: (Configuration.Present) -> Void) {
        let _configuration = BaseConfiguration(action: .present)
        
        configuration(Configuration.Present(with: _configuration))
        
        Navigator(configuration: _configuration).execute(nil)
    }
    
    public static func push(_ configuration: (Configuration.Push) -> Void) {
        let _configuration = BaseConfiguration(action: .push)
        
        configuration(Configuration.Push(with: _configuration))
        
        Navigator(configuration: _configuration).execute(nil)
    }
    
    public static func response(_ configuration: (Configuration.Response) -> Void) {
        let _configuration = BaseConfiguration(action: .response)
        configuration(Configuration.Response(with: _configuration))
    }
}
