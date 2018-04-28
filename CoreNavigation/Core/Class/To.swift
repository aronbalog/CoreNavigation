import Foundation
import UIKit

/// Define destination.
public class To<ResultableType: Resultable>: DestinationAware {
    // MARK: Public

    /// Assigns view controller to navigate to.
    ///
    /// - Example: Simple navigation to view controller instance.
    ///     ````
    ///     Navigate.present { $0
    ///        .to(UIViewController())
    ///     }
    ///     ````
    ///
    /// - Parameter viewController: A view controller instance.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T>(_ viewController: T) -> Configuration<Result<T, Any>> where T: UIViewController {
        let configuration = Configuration<Result<T, Any>>(request: .viewController(viewController), from: from)

        navigate(with: configuration)

        return configuration
    }

    /// Assigns data receivable view controller to navigate to.
    ///
    /// - Example: Simple navigation to view controller instance.
    ///     ````
    ///     let viewController: DataReceivable = ViewController()
    ///
    ///     Navigate.present { $0
    ///        .to(viewController)
    ///     }
    ///     ````
    ///
    /// - Parameter viewController: A view controller instance conforming `DataReceivable` protocol.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivable>(_ viewController: T) -> Configuration<Result<T, T.DataType>> {
        let configuration = Configuration<Result<T, T.DataType>>(request: .viewController(viewController), from: from)

        navigate(with: configuration)

        return configuration
    }

    /// Assigns view controller class to navigate to.
    ///
    /// - Example: Simple navigation to view controller class.
    ///     ````
    ///     Navigate.present { $0
    ///        .to(UIViewController.self)
    ///     }
    ///     ````
    ///
    /// - Parameter viewControllerClass: A view controller class.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T>(_ viewControllerClass: T.Type) -> Configuration<Result<T, Any>> where T: UIViewController {
        let viewController = viewControllerClass.init()
        let configuration = Configuration<Result<T, Any>>(request: .viewController(viewController), from: from)

        navigate(with: configuration)

        return configuration
    }

    /// Assigns data receivable view controller class to navigate to.
    ///
    /// - Example: Simple navigation to view controller instance.
    ///     ````
    ///     let viewControllerClass: DataReceivable.Type = ViewController.self
    ///
    ///     Navigate.present { $0
    ///        .to(viewControllerClass)
    ///     }
    ///     ````
    ///
    /// - Parameter viewControllerClass: A view controller class conforming `DataReceivable` protocol.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivable>(_ viewControllerClass: T.Type) -> Configuration<Result<T, T.DataType>> {
        let viewController = viewControllerClass.init()
        let configuration = Configuration<Result<T, T.DataType>>(request: .viewController(viewController), from: from)

        navigate(with: configuration)

        return configuration
    }

    /// Assigns block which can be used to resolve view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller instance to this block when navigation is wanted.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T>(_ block: @escaping (@escaping (T) -> Void) -> Void) -> Configuration<Result<T, Any>> where T: UIViewController {
        let viewControllerBlock: (@escaping (Request<T>.Result) -> Void) -> Void = { resultBlock in
            block { viewController in
                resultBlock(.success(viewController))
            }
        }

        let configuration = Configuration<Result<T, Any>>(request: .viewControllerBlock(viewControllerBlock), from: from)

        navigate(with: configuration)

        return configuration
    }

    /// Assigns block which can be used to resolve data receivable view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller instance conforming `DataReceivable` protocol to this block when navigation is wanted.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivable>(_ block: @escaping (@escaping (T) -> Void) -> Void) -> Configuration<Result<T, T.DataType>> {
        let viewControllerBlock: (@escaping (Request<T>.Result) -> Void) -> Void = { resultBlock in
            block { viewController in
                resultBlock(.success(viewController))
            }
        }

        let configuration = Configuration<Result<T, T.DataType>>(request: .viewControllerBlock(viewControllerBlock), from: from)

        navigate(with: configuration)

        return configuration
    }

    /// Assigns block which can be used to resolve view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller class to this block when navigation is wanted.
    /// - Returns: `Configuration` object
    @discardableResult public func to<T>(_ block: @escaping (@escaping (T.Type) -> Void) -> Void) -> Configuration<Result<T, Any>> where T: UIViewController {
        let viewControllerClassBlock: (@escaping (Request<T>.Result) -> Void) -> Void = { resultBlock in
            block { viewControllerClass in
                resultBlock(.success(viewControllerClass))
            }
        }

        let configuration = Configuration<Result<T, Any>>(request: .viewControllerClassBlock(viewControllerClassBlock), from: from)

        navigate(with: configuration)

        return configuration
    }

    /// Assigns block which can be used to resolve data receivable view controller asynchronously.
    ///
    /// - Parameter block: Pass view controller class conforming `DataReceivable` protocol to this block when navigation is wanted.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: DataReceivable>(_ block: @escaping (@escaping (T.Type) -> Void) -> Void) -> Configuration<Result<T, T.DataType>> {
        let viewControllerClassBlock: (@escaping (Request<T>.Result) -> Void) -> Void = { resultBlock in
            block { viewControllerClass in
                resultBlock(.success(viewControllerClass))
            }
        }

        let configuration = Configuration<Result<T, T.DataType>>(request: .viewControllerClassBlock(viewControllerClassBlock), from: from)

        navigate(with: configuration)

        return configuration
    }

    /// Assigns destination resolving its `ViewController` associated type to UIViewController class or subclass.
    ///
    /// - Parameter destination: Destination object resolving it's `ViewController` type to `UIViewController` class or subclass.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: Destination>(_ destination: T) -> Configuration<Result<T.ViewControllerType, Any>> {
        let context = Context<T>(parameters: destination.parameters)

        let configuration = Configuration<Result<T.ViewControllerType, Any>>(request: .viewControllerBlock({ block in
            context.destinationBlocks.append({ (viewController, _) in
                block(.success(viewController))
            })
            context.cancelBlocks.append({ (error) in
                block(.failure(error))
            })
        }), from: from)

        navigate(with: configuration, completion: {
            type(of: destination).resolve(context: context)
        })

        return configuration
    }

    /// Assigns destination resolving its `ViewController` associated type to UIViewController class or subclass conforming `DataReceivable` protocol.
    ///
    /// - Parameter destination: Destination object resolving it's `ViewController` type to `UIViewController` class or subclass conforming `DataReceivable` protocol.
    /// - Returns: `Configuration` object.
    @discardableResult public func to<T: Destination>(_ destination: T) -> Configuration<Result<T.ViewControllerType, T.ViewControllerType.DataType>> where T.ViewControllerType: DataReceivable {
        let context = Context<T>(parameters: destination.parameters)

        let configuration = Configuration<Result<T.ViewControllerType, T.ViewControllerType.DataType>>(request: .viewControllerBlock({ block in
            context.destinationBlocks.append({ (viewController, _) in
                block(.success(viewController))
            })
            context.cancelBlocks.append({ (error) in
                block(.failure(error))
            })
        }), from: from)

        navigate(with: configuration, completion: {
            type(of: destination).resolve(context: context)
        })

        return configuration
    }

    /// Assigns registered destination's URL to navigate to.
    ///
    /// - Parameter url: URL instance.
    /// - Returns: `Configuration` object.
    @discardableResult public func to(_ url: URL) -> Configuration<Result<UIViewController, Any>> {
        return To.to(matchable: url, from: from, action: { configuration in
            navigate(with: configuration)
        })
    }

    /// Assign registered destination's path to navigate to.
    ///
    /// - Parameter path: String instance
    /// - Returns: `Configuration` object.
    @discardableResult public func to(_ path: String) -> Configuration<Result<UIViewController, Any>> {
        return To.to(matchable: path, from: from, action: { configuration in
            navigate(with: configuration)
        })
    }

    /// Assign registered destination's uri to navigate to.
    ///
    /// - Parameter matchable: Matchable object.
    /// - Returns: `Configuration` object.
    @discardableResult public func to(_ matchable: Matchable) -> Configuration<Result<UIViewController, Any>> {
        return To.to(matchable: matchable, from: from, action: { configuration in
            navigate(with: configuration)
        })
    }

    // MARK: Internal

    let navigationType: NavigationType
    var destination: Request<ResultableType.ToViewController>?
    let from: UIViewController?

    init(_ navigationType: NavigationType, from: UIViewController?) {
        self.navigationType = navigationType
        self.from = from
    }

    @discardableResult static func to<T>(matchable: Matchable, from: UIViewController?, action: (Configuration<Result<T, Any>>) -> Void) -> Configuration<Result<T, Any>> {

        let match = Navigate.router.match(for: matchable)

        var _configuration: Configuration<Result<T, Any>>?

        let viewControllerBlock: (@escaping (Request<T>.Result<T>) -> Void) -> Void = { (handler) in
            guard let match = match else {
                // not matched
                handler(.failure(NavigationError.Destination.notFound))
                return
            }

            let destinationType = match.destinationType
            let parameters = match.parameters

            destinationType.resolve(parameters: parameters, destination: { (destination, data) in
                if let data = data {
                    _configuration?.dataPassing.data = data
                }

                handler(.success(destination as! T))
            }, failure: { error in
                handler(.failure(error ?? NavigationError.unknown))
            })
        }

        let configuration = Configuration<Result<T, Any>>(request: .viewControllerBlock(viewControllerBlock), from: from)
        _configuration = configuration

        action(configuration)

        return configuration
    }

    // MARK: private

    private func navigate<T>(with configuration: Configuration<T>, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            Navigator.navigate(with: self.navigationType, configuration: configuration, completion: completion)
        }
    }
}
