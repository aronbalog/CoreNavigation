import Foundation

protocol Application: class {
    associatedtype Application: ApplicationAware
    
    var application: Application { get set }
    
    @discardableResult func `in`(application: UIApplicationProtocol) -> Self
}

extension Configuration: Application {
    @discardableResult public func `in`(application: UIApplicationProtocol) -> Self {
        self.application.application = application
        
        return self
    }
}
