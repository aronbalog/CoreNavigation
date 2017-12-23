# API Reference ⌨️

- 📲 [Destination](#destination-) (view controller to navigate to)
    - [Passing instance](#passing-instance)
    - [Passing class](#passing-class)
    - [Passing route](#passing-route)
- 📡 [Passing data between view controllers](#passing-data-between-view-controllers-)
- 🎞 [Transitioning](#transitioning-)
    - [Animation](#animation)
    - [Transitioning delegate](#transitioning-delegate)
    - [Completion](#completion)
- 🎯 [View controller events](#view-controller-events-)
- ♻️ [Caching](#caching-%EF%B8%8F)
    - [Lifetime protocol](#lifetime-protocol)
- 👮 [Protection](#protection-)

## Destination 📲

Destination can be:

- `UIViewController` instance
- `UIViewController` class
- `Route` or `AbstractRoute` resolving it's destionation to `UIViewController`

Usage:

### Passing instance

`.to(_ viewController: UIViewController)`

### Passing class

`.to(_ viewControllerType: UIViewController.Type)`

[UIViewController documentation][UIViewController]

### Passing route

`.to(_ route: AbstractRoute)`

Routing capabilities are avaliable as external plugin.

[Routing documentation](ROUTING_DOCUMENTATION.md)

## Passing data between view controllers 📡

Passing and receiving data between view controllers can be easily achieved.

#### Sending parameters

```swift
Navigation.present { $0    
    ...
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
Navigation.present { $0    
    ...
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

This wrapps argument passed to:

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

Note:

*Although* `pushViewController(UIViewController, animated: Bool)` *method does not have* `completion` *argument,* **CoreNavigation** *has its own implementation to achive this.*


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

There are two methods you have to implement:

- `init()`
    - Setup your lifetime object in `init()`
- `func die(_ kill: @escaping () -> Void)`
    - call `kill()` to invalidate cache

#### Simple use case

Let's say following use case has to be implemented:

1. When some action `A1` occurs (eg. button is tapped), `VC1` is presented
1. 
    - If `VC1` is dismissed and `A1` action is repeated within `60` seconds, presented `VC1` should be the same instance from `step 1` of this use case
    - Otherwise, new instance of `VC1` should be presented

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
Navigation.present { $0
    .to(VC1.self)
    .keepAlive(within: Age(seconds: 60), identifier: "CACHE_IDENTIFIER")
}
```

## Protection 👮

TODO

[UIViewController]: https://developer.apple.com/documentation/uikit/uiviewcontroller
[UIViewControllerTransitioningDelegate]: https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioningdelegate