public protocol Buildable {
    associatedtype DestinationType: Destination
    associatedtype FromType: UIViewController
    
    init(configuration: Configuration<DestinationType, FromType>, queue: DispatchQueue)
    
    var configuration: Configuration<DestinationType, FromType> { get }
    var queue: DispatchQueue { get }
}
