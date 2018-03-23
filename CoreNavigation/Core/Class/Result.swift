import Foundation

public class Result<T1: UIViewController, T2>: Resultable {    
    public typealias ToViewController = T1
    public typealias DataType = T2
}
