import Foundation

public protocol ParametersAware where Self: UIViewController {
    associatedtype ParametersType
    
    func didReceiveParameters(_ parameters: ParametersType)
}
