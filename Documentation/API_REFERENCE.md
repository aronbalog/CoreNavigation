# API Reference ⌨️

- [Destination](#destination-) (view controller to navigate to)
    - [Passing instance](#passing-instance)
    - [Passing class](#passing-class)
    - [Passing route](#passing-route)
- [Passing data between view controllers](#passing-data-between-view-controllers-)
- [Transitioning](#transitioning-)
    - [Animation](#animation)
    - [Transitioning delegate](#transitioning-delegate)
    - [Completion](#completion)
- [View controller events](#view-controller-events-)
- [Caching](#caching-%EF%B8%8F)
    - [Lifetime protocol](#lifetime-protocol)
- [Protection](#protection-)
- [State restoration](#state-restoration-%EF%B8%8F)
    - [StateRestorationDelegate protocol](#staterestorationdelegate-protocol)

## Destination 📲

Destination can be:

- `UIViewController` instance
- `UIViewController` class
- or `Route` or `AbstractRoute` resolving it's destionation to `UIViewController`

Usage:

### Passing instance

`.to(_ viewController: UIViewController)`

### Passing class

`.to(_ viewControllerType: UIViewController.Type)`

[UIViewController documentation][UIViewController]

### Passing route

`.to(_ route: AbstractRoute)`

Routing capabilities are avaliable as external plugin and explained in the [separate document](ROUTING_DOCUMENTATION.md).

## Passing data between view controllers 📡

Passing and receiving data between view controllers can be easily achieved.

#### Sending parameters

```swift
Navigation.present { (navigate) in    
    navigate
        .to(MyViewController.self)
        .pass(parameters: [
            "firstName": "john",
            "lastName": "doe"
        ])
}
```

#### Receiving response

Conform your view controllers to `ResponseAware` protocol and implement:

```swift
func didReceiveResponse(_ response: Response) {
    // response.parameters -> ["firstName": "john", "lastName": "doe"]        
}
```

## Transitioning 🎞

CoreNavigation provides API wrapper around:

- [`present(UIViewController, animated: Bool, completion: (() -> Void)? = nil)`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621380-present)
- [`pushViewController(UIViewController, animated: Bool)`](https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621887-pushviewcontroller)
- [`transitioningDelegate: UIViewControllerTransitioningDelegate?`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621421-transitioningdelegate)


#### Full example

```swift
Navigation.present { (navigate) in    
    navigate
        .to(MyViewController.self)
        .animated(false)
        .transitioningDelegate(transitioningDelegate)
        .completion {
                    
        }
}
```

### Animation

#### Usage

`.animated(_ animated: Bool)`

#### Description

Not calling this function or passing `true` will navigate with animation (default behaviour). If `false` is passed, navigation will perform without animation.

Argument is passed as `animated` argument in:

`pushViewController(UIViewController, animated: Bool)`

and

`present(UIViewController, animated: Bool, completion: (() -> Void)? = nil)`

### Transitioning delegate

#### Usage

`.transitioningDelegate(_ transitioningDelegate: UIViewControllerTransitioningDelegate?)`

#### Description

Pass the delegate object that provides transition animator, interactive controller, and custom presentation controller objects.

[UIViewControllerTransitioningDelegate documentation][UIViewControllerTransitioningDelegate]

### Completion

#### Usage

```swift
.completion {
    // your code
} 
```

#### Description

The block to execute after the navigation finishes (after the `viewDidAppear(_:)` method is called on the presented view controller).

Argument is passed as `completion` argument in:

- `present(UIViewController, animated: Bool, completion: (() -> Void)? = nil)`

This block has no return value and takes no parameters.

>  Note:
>
> Although `pushViewController(UIViewController, animated: Bool)` method does not have `completion` argument, **CoreNavigation** has its own implementation to achive this.


## View controller events 🎯

#### Usage

```swift
.viewControllerEvents({ (events, viewController) in
    events
        .viewDidLoad {
            // called on `viewDidLoad()`
        }
})
```

#### Description

Used for observing `UIViewController` events.

List of `UIViewController` events avaliable for observing:

- `loadView()`
- `viewDidLoad()`
- `viewWillAppear(_ animated: Bool)`
- `viewDidAppear(_ animated: Bool)`
- `viewWillDisappear(_ animated: Bool)`
- `viewDidDisappear(_ animated: Bool)`
- `viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)`
- `viewWillLayoutSubviews()`
- `viewDidLayoutSubviews()`
- `updateViewConstraints()`
- `willMove(toParentViewController: UIViewController?)`
- `didMove(toParentViewController: UIViewController?)`
- `didReceiveMemoryWarning()`
- `applicationFinishedRestoringState()`
- `viewLayoutMarginsDidChange()`
- `viewSafeAreaInsetsDidChange()`

## Caching ♻️

#### Usage

`.keepAlive(within: Lifetime.Type, identifier: String)`

#### Description

Pass any class conforming `Lifetime` protocol.

### `Lifetime` protocol

There are two methods that have to be implemented:

- `init()`
    - Setup your lifetime object in `init()`
- `func die(_ kill: @escaping () -> Void)`
    - call `kill()` to invalidate cache

#### Simple use case

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
Navigation.present { (navigate) in
    navigate
        .to(VC1.self)
        .keepAlive(within: Age(seconds: 60), identifier: "CACHE_IDENTIFIER")
}
```

## Protection 👮

#### Usage

`.protect(with: ProtectionSpace)`

#### Description

Pass any class conforming `ProtectionSpace` protocol.

### `ProtectionSpace` protocol

There is one method that has to be implemented:

- `func shouldProtect(unprotect: @escaping () -> Void, failure: @escaping (Error) -> Void) -> Bool`
    - call `unprotect()` when you are ready to execute navigation

#### Simple use case

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
            Navigation.present { (present) in
                present
                    .to(AuthVC.self)
                    .onSuccess({ (response) in
                        authenticationService.userDidSignIn {
                            // `authenticationService.isUserSignedIn` now resolves to `true`               
                            
                            // dismiss AuthVC                    
                            response.toViewController?.dismiss(animated: true, completion: {
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
    Navigation.present { (navigate) in
        navigate
            .to(VC1.self)
            .protect(with: Auth())
    }
    ```

## State restoration ↪️

CoreNavigation interacts with iOS state restoration engine and provides solution to cases where some checks has to be done before state restoration should continue. However, there are some prerequisites that have to be met:

- If you do not use storyboards and instead create your window and root view controller in code, make sure you create them in AppDelegate's `application:willFinishLaunchingWithOptions:` instead of `application:didFinishLaunchingWithOptions:`

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
        var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        lazy var rootViewController = ViewController()
            
        func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
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
                return .protect(protectionSpace: Auth())
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

#### Usage


To handle state restoration automatically:

`.withStateRestoration()`

To handle state restoration automatically with ability to pass custom restoration identifier:

`.withStateRestoration(restorationIdentifier: String)`

To handle state restoration manually:

`.withManualStateRestoration(restorationIdentifier: String, restorationClass: UIViewControllerRestoration.Type?)`


> Note:
> 
> If you handle state restoration automatically (using CoreNavigation engine), then your `AppDelegate` must conform `StateRestorationDelegate` protocol.

### `StateRestorationDelegate` protocol

There is one method that has to be implemented:

- `func application(_ application: UIApplication, stateRestorationBehaviorForContext context: StateRestorationContext) -> StateRestorationBehavior`

    When state restoration is handled through *CoreNavigation*, on app launch App delegate will be asked to provide behavior for single state restoration case.
    
    Method must return a case from `StateRestorationBehavior` enum:
    
    | Case                                        | Description |
    | :------------------------------------------ | :---------- |
    | `allow`                                     | State restoration should be processed. | 
    | `reject`                                    | State restoration should NOT be processed. |
    | `protect(protectionSpace: ProtectionSpace)` | State restoration should be protected with an object conforming `ProtectionSpace`. Unprotection block from this object must be called on same thread to support state restoration because state restoration engine needs view controller immediately to be able to restore it.<br><br>If you want to handle a case asynchronously, you can use `onUnprotect` handler in `StateRestorationContext` where you will be provided with view controller instance. Use it as you wish. |
    
    
    Method will receive `StateRestorationContext` object (used for meta purposes) which has following properties:

    | Property name        | Type           | Description  |
    | :------------- |:-------------:| :----- |
    | `restorationIdentifier` | `String` | State restoration identifier which can be explicitly passed in `.withStateRestoration(restorationIdentifier: String)` or is internally generated by *CoreNavigation*) when `.withStateRestoration()` is called. |
    | `viewControllerClass` | `UIViewController.Type` | A view controller class that is going to be restored. |
    | `protectionSpaceClass` | `AnyClass?` | A class of object passed in `protect(with:)` method. |
    | `parameters` | `[String: Any]?` | Parameters passed in `pass(parameters:)` method. |   
    
    > Note:
    >
    > View controllers restored by *CoreNavigation* state restoration engine & conformed to `ResponseAware` protocol will receive response with parameters passed during navigation so `decodeRestorableState(with:)` and `encodeRestorableState(with:)` can be ignored if you use these just for decoding parameters. Also, parameters passed during navigation must conform to `NSCoding` protocol when used with state restoration.


[UIViewController]: https://developer.apple.com/documentation/uikit/uiviewcontroller
[UIViewControllerTransitioningDelegate]: https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioningdelegate