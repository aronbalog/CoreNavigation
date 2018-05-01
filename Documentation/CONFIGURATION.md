# Configuration

Every navigation operation is highly customizable. Define your configuration by chaining configuration methods in configuration block.

Configuration options:

- [Animating]
- [Observing completion]
- [Observing success]
- [Observing failure]
- [Embedding]
- [Passing data]
- [Caching]
- [Protection]
- [State restoration]
- [Specifying origin view controller]

More details about options are available on the [Documentation page](https://docs.corenavigation.org/Classes/Configuration.html).

<!---
unsafely()
trackKeyboard(with:)
inWindow(_:)
on(_:)
-->

[Animating]: #animating
[Observing completion]: #observing-completion
[Observing success]: #observing-success
[Observing failure]: #observing-failure
[Embedding]: #embedding
[Passing data]: #passing-data
[Caching]: #caching
[Protection]: #protection
[State restoration]: #state-restoration
[Specifying origin view controller]: #specifying-origin-view-controller

## Animating

### Usage

| Method                        | Arguments                                 |
| :-----------------------------| :-----------------------------------------|
| [`animated(_:)`]              | `Bool`                                    |

> By passing false, transition will perform without animation. Default: `true`

| Method                        | Arguments                                 |
| :-----------------------------| :-----------------------------------------|
| [`transitioningDelegate(_:)`] | [`UIViewControllerTransitioningDelegate`] |

> Pass the delegate object that provides transition animator, interactive controller, and custom presentation controller objects.

## Observing completion

### Usage

| Method             | Arguments    |
| :------------------| :------------|
| [`completion(_:)`] | `() -> Void` |

> The block to execute after the navigation finishes (after the `viewDidAppear(_:)` method is called on the presented view controller).

## Observing success

### Usage

| Method            | Arguments            |
| :-----------------| :--------------------|
| [`onSuccess(_:)`] | [`(Result) -> Void`] |

>  The block to execute before the navigation starts (after the view controller is instantiated).

## Observing failure

### Usage

| Method            | Arguments         |
| :-----------------| :-----------------|
| [`onFailure(_:)`] | `(Error) -> Void` |

> The block to execute on navigation failure.

## Embedding

### Usage

| Method                               | Arguments                  |
| :------------------------------------| :--------------------------|
| [`embedded(in:)`][embeddedIn1]       | [`EmbeddingType`]          |

> Embeds view controller in another view controller. Pass [`EmbeddingType`] enum to specify behavior.

| Method                               | Arguments                  |
| :------------------------------------| :--------------------------|
| [`embedded(in:)`][embeddedIn2]       | [`EmbeddingProtocol.Type`] |

> Embeds view controller in another view controller. Pass type conforming [`EmbeddingProtocol`].

| Method                               | Arguments                  |
| :------------------------------------| :--------------------------|
| [`embeddedInNavigationController()`] | *None*                     |

> Embeds view controller in [`UINavigationController`].

## Passing data

### Usage

| Method                      | Arguments               |
| :---------------------------| :-----------------------|
| [`passData(_:)`][passData1] | `Any`                   |
| [`withData(_:)`][withData1] | `Any`                   |
| [`passData(_:)`][passData2] | `T`                     |
| [`withData(_:)`][withData2] | `T`                     |
| [`passDataInBlock(_:)`]     | `((T) -> Void) -> Void` |
| [`withDataInBlock(_:)`]     | `((T) -> Void) -> Void` |

> TODO: describe usage

## Caching

### Usage

| Method                                 | Arguments              |
| :--------------------------------------| :----------------------|
| [`keepAlive(within:cacheIdentifier:)`] | [`Lifetime`], `String` |

> Pass an object conforming [`Lifetime`] protocol.

### `Lifetime` protocol

Implement following method:

- `func die(_ kill: @escaping () -> Void)`

Call `kill()` to invalidate cache.

### Simple use case

Let's say following use case has to be implemented:

Let's say following use case has to be implemented:

> 1. When some action `A1` occurs (eg. button is tapped), `VC1` is presented
> 1. 
>    - If `VC1` is dismissed and `A1` action is repeated within `60` seconds, presented `VC1` should be the same instance from `step 1` of this use case
>    - Otherwise, new instance of `VC1` should be presented

This can be easily achieved by passing an object conforming `Lifetime` protocol.

Let's make an object that is representing some time duration, in this case - seconds. It has just one property:
 
- `let seconds: TimeInterval`

```swift
class Age: Lifetime {
    let seconds: TimeInterval
    
    init(seconds: TimeInterval) {
        self.seconds = seconds
    }
    
    func die(_ kill: @escaping () -> Void) {
        print("will invalidate cache in \(seconds) second(s)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            kill()
            print("Cache invalidated")
        }
    }
}
```

Applying `Lifetime` to navigation: 

```swift
Navigate.present { $0
    .to(VC1.self)
    .keepAlive(within: Age(seconds: 60), identifier: "CACHE_IDENTIFIER")
}
```

## Protection

### Example app

- [BiometricAuthExample](Examples/BiometricAuthExample)

### Usage

| Method             | Arguments           |
| :------------------| :-------------------|
| [`protect(with:)`] | [`ProtectionSpace`] |

> Pass an object conforming [`ProtectionSpace`] protocol.

### `ProtectionSpace` protocol

Implement following method:

- `func shouldProtect(unprotect: @escaping () -> Void, failure: @escaping (Error) -> Void) -> Bool`
    
Call `unprotect()` when you are ready to execute navigation.

### Simple use case

> 1. Unauthenticated user initiates navigation to `VC1` that is available only to authenticated users
> 1. When such navigation is requested, `VC1` should not open immediately
> 1. Authentication view controller `VC2` is presented
> 1. When user is finally authenticated, `VC2` is dismissed and `VC1` is presented automatically without need to initiate navigation again

How to achieve this?

1. Declare protection space:
    
    ```swift
    class Auth: ProtectionSpace {
        let authenticationService = SomeAuthService()
        
        // MARK: ProtectionSpace
        
        func shouldProtect(unprotect: @escaping () -> Void, failure: @escaping (Error) -> Void) -> Bool {
            guard let shouldProtect = !authenticationService.isUserSignedIn else {
                // should not protect if user is signed in
                return false
            }
    
            // present some AuthVC
            Navigate.present { $0
                .to(AuthVC.self)
                .onSuccess({ (result) in
                    authenticationService.userDidSignIn {
                        // `authenticationService.isUserSignedIn` now resolves to `true`               
                        
                        // dismiss AuthVC                    
                        result.toViewController?.dismiss(animated: true, completion: {
                            // unprotect and proceed with navigation
                            unprotect()
                        })
                    }
                    
                    authenticationService.userDidFailToSignIn { error in
                        // pass error if want to trigger onFailure blocks
                        // on main navigation request
                        failure(error)
                    }
                })
            }
            
            return shouldProtect
        }
    }
    ```

1. Apply `ProtectionSpace` instance to navigation:

    ```swift
    Navigate.present { (navigate) in
        navigate
            .to(VC1.self)
            .protect(with: Auth())
    }
    ```


## State restoration

### Intro

`CoreNavigation` interacts with iOS state restoration engine and provides solution to cases where some checks has to be done before state restoration should continue. However, there are some prerequisites that have to be met:

- If you do not use storyboards and instead create your window and root view controller in code, make sure you create them in AppDelegate's [`application:willFinishLaunchingWithOptions:`] instead of [`application:didFinishLaunchingWithOptions:`]

    From Apple's [documentation](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623032-application):
    

    >    Important
    >
    > If your app relies on the state restoration machinery to restore its view controllers, always show your app’s window from this method. Do not show the window in your app’s application(_:didFinishLaunchingWithOptions:) method. Calling the window’s makeKeyAndVisible() method does not make the window visible right away anyway. UIKit waits until your app’s application(_:didFinishLaunchingWithOptions:) method finishes before making the window visible on the screen.

- Conform your App delegate to `StateRestorationDelegate` and implement:
    - `application:shouldSaveApplicationState:`
    - `application:shouldRestoreApplicationState:`
    - `application:stateRestorationBehaviorForContext:`
    
    Example:

    ```swift
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate, StateRestorationDelegate {
        var window: UIWindow? = UIWindow()
        lazy var rootViewController = ViewController()
            
        func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
            rootViewController?.restorationIdentifier = "root"
            window?.restorationIdentifier = "main_window"
            window?.rootViewController = rootViewController
            window?.makeKeyAndVisible()
            
            return true
        }

        func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
            return true
        }
    
        func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
            return true
        }
        
        func application(_ application: UIApplication, stateRestorationBehaviorForContext context: StateRestorationContext) -> StateRestorationBehavior {
            // check if restoration is heading to some protected view controller

            if context.identifier == "my-account" {
                return .protect(protectionSpace: Auth(), onUnprotect: nil, onFailure: nil)
            }            
            
            context.onUnprotect { (viewController: UIViewController) in
                // if you unprotect state restoration on different thread, you can manually present resolved view controller from here
            }
            
            return .allow // or .reject if state restoration is not wanted
        }
        
        func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
            /*
            Fallback to default iOS state restoration handling.
            Only implement this method if you handle state restoration manually.
            */

            return nil
        }
    }
    ```
    
### Usage

| Method                                 | Arguments                                      |
| :--------------------------------------| :----------------------------------------------|
| [`stateRestorable()`]                  | *None*                                         |

> Prepares view controller for state restoration.
> 
> *If you use this method, then your `AppDelegate` must conform [`StateRestorationDelegate`] protocol.*

| Method                                 | Arguments                                      |
| :--------------------------------------| :----------------------------------------------|
| [`stateRestorable(identifier:)`]       | `String`                                       |

> Prepares view controller for state restoration with ability to pass custom restoration identifier.
> 
> *If you use this method, then your `AppDelegate` must conform [`StateRestorationDelegate`] protocol.*

| Method                                 | Arguments                                      |
| :--------------------------------------| :----------------------------------------------|
| [`stateRestorable(identifier:class:)`] | `String`, [`UIViewControllerRestoration.Type`] |

> Prepares view controller for state restoration with ability to pass custom restoration identifier and class.

### [`StateRestorationDelegate`] protocol

Implement following method:

- `func application(_ application: UIApplication, stateRestorationBehaviorForContext context: StateRestorationContext) -> StateRestorationBehavior`

    When state restoration is handled through `CoreNavigation`, on app launch `AppDelegate` will be asked to provide behavior for single state restoration case.

    Method must return a case from [`StateRestorationBehavior`] enum.    
    
    Method will receive [`StateRestorationContext`] argument (used for meta purposes) which has following properties:

    | Property name           | Type                    | Description                                              |
    | :---------------------- |:-----------------------:| :------------------------------------------------------- |
    | `restorationIdentifier` | `String`                | State restoration identifier applied to view controller. |
    | `viewControllerClass`   | `UIViewController.Type` | A view controller class that is going to be restored.    |
    | `protectionSpaceClass`  | `AnyClass?`             | A class of object passed in `protect(with:)` method.     |
    | `data`                  | `Any?`                  | Data passed in [`passData(_:)`][passData1] method.       |
    
**Note**
View controllers restored by `CoreNavigation` state restoration engine & conforming `DataReceivable` protocol will receive data passed during navigation so there is no need to rely on `decodeRestorableState(with:)` and `encodeRestorableState(with:)`. To support this feature, passed data must conform to [`NSCoding`] protocol.

## Specifying origin view controller

### Usage

| Method       | Arguments            |
| :------------| :--------------------|
| [`from(_:)`] | [`UIViewController`] |

> `CoreNavigation` automatically determines visible view controller which is used to navigate from. Calling this method will override this behavior.


[`animated(_:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC8animatedACyxGXDSbF
[`transitioningDelegate(_:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC21transitioningDelegateACyxGXDSo029UIViewControllerTransitioningE0_pF
[`completion(_:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC10completionACyxGXDyycF
[`onSuccess(_:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC9onSuccessACyxGXDyxcF
[`onFailure(_:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC9onFailureACyxGXDys5Error_pcF
[embeddedIn1]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC8embeddedACyxGXDAA13EmbeddingTypeO2in_tF
[embeddedIn2]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC8embeddedACyxGXDAA17EmbeddingProtocol_pXp2in_tF
[`embeddedInNavigationController()`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC010embeddedInB10ControllerACyxGXDyF
[passData1]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC8passDataACyxGXDypF
[withData1]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC8withDataACyxGXDypF
[passData2]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationCA2A10ResultableRzAA14DataReceivable16ToViewControllerRpzlE04passE0ACyAA6ResultCyAgF_0E4TypeQZGGALF
[withData2]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationCA2A10ResultableRzAA14DataReceivable16ToViewControllerRpzlE04withE0ACyAA6ResultCyAgF_0E4TypeQZGGALF
[`passDataInBlock(_:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationCA2A10ResultableRzAA14DataReceivable16ToViewControllerRpzlE04passE7InBlockACyAA6ResultCyAgF_0E4TypeQZGGyyALccF
[`withDataInBlock(_:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationCA2A10ResultableRzAA14DataReceivable16ToViewControllerRpzlE04withE7InBlockACyAA6ResultCyAgF_0E4TypeQZGGyyALccF
[`keepAlive(within:cacheIdentifier:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC9keepAliveACyxGXDAA8Lifetime_p6within_SS15cacheIdentifiertF
[`protect(with:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC7protectACyxGXDAA15ProtectionSpace_p4with_tF
[`stateRestorable()`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC15stateRestorableACyxGXDyF
[`stateRestorable(identifier:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC15stateRestorableACyxGXDSS10identifier_tF
[`stateRestorable(identifier:class:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC15stateRestorableACyxGXDSS10identifier_So27UIViewControllerRestoration_pXp5classtF
[`from(_:)`]: https://docs.corenavigation.org/Classes/Configuration.html#/s:14CoreNavigation13ConfigurationC4fromACyxGXDqd__So16UIViewControllerCRbd__lF
[`application:willFinishLaunchingWithOptions:`]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623032-application
[`application:didFinishLaunchingWithOptions:`]: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application

[`UIViewControllerTransitioningDelegate`]: https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioningdelegate
[`EmbeddingType`]: https://docs.corenavigation.org/Enums/EmbeddingType.html
[`EmbeddingProtocol`]: https://docs.corenavigation.org/Protocols/EmbeddingProtocol.html
[`EmbeddingProtocol.Type`]: https://docs.corenavigation.org/Protocols/EmbeddingProtocol.html
[`Lifetime`]: https://docs.corenavigation.org/Protocols/Lifetime.html
[`ProtectionSpace`]: https://docs.corenavigation.org/Protocols/ProtectionSpace.html
[`UIViewControllerRestoration.Type`]: https://developer.apple.com/documentation/uikit/uiviewcontrollerrestoration
[`(Result) -> Void`]: https://docs.corenavigation.org/Classes/Result.html
[`UIViewController`]: https://developer.apple.com/documentation/uikit/uiviewcontroller
[`UINavigationController`]: https://developer.apple.com/documentation/uikit/uinavigationcontroller
[`StateRestorationDelegate`]: https://docs.corenavigation.org/Protocols/StateRestorationDelegate.html
[`StateRestorationBehavior`]: https://docs.corenavigation.org/Enums/StateRestorationBehavior.html
[`NSCoding`]: https://developer.apple.com/documentation/foundation/nscoding
[`StateRestorationContext`]: https://docs.corenavigation.org/Classes/StateRestorationContext.html