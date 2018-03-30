![](Documentation/Assets/cover-image.png)

# CoreNavigation 📱📲

Navigate between view controllers with ease. 💫

[![Build Status](https://travis-ci.org/aronbalog/CoreNavigation.svg?branch=master)](https://travis-ci.org/aronbalog/CoreNavigation)
[![Platform](https://img.shields.io/cocoapods/p/CoreNavigation.svg?style=flat)](https://github.com/aronbalog/CoreNavigation)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CoreNavigation.svg)](https://img.shields.io/cocoapods/v/CoreNavigation.svg)

- 📋 [Synopsis](#synopsis-)
- ✊ [Motivation](#motivation-)
- 🚀 [Getting Started](#getting-started-)
- 💻 [Example Use](#example-use-)
- ⌨️ [API Reference](#api-reference-%EF%B8%8F)
    - [Defining destination](Documentation/API_REFERENCE.md#destination-) (view controller to navigate to)
        - [Instance](Documentation/API_REFERENCE.md#passing-instance)
        - [Class](Documentation/API_REFERENCE.md#passing-class)
        - [Routing](Documentation/API_REFERENCE.md#passing-route)
    - [Passing data between view controllers](Documentation/API_REFERENCE.md#passing-data-between-view-controllers-)
    - [Transitioning](Documentation/API_REFERENCE.md#transitioning-)
        - [Animation](Documentation/API_REFERENCE.md#animation)
        - [Transitioning delegate](Documentation/API_REFERENCE.md#transitioning-delegate)
        - [Completion](Documentation/API_REFERENCE.md#completion)
    - [View controller events](Documentation/API_REFERENCE.md#view-controller-events-)
    - [Caching](Documentation/API_REFERENCE.md#caching-%EF%B8%8F)
        - [Lifetime protocol](Documentation/API_REFERENCE.md#lifetime-protocol)
    - [Protection](Documentation/API_REFERENCE.md#protection-)
    - [State restoration](Documentation/API_REFERENCE.md#state-restoration-%EF%B8%8F)
        - [StateRestorationDelegate protocol](Documentation/API_REFERENCE.md#staterestorationdelegate-protocol)
    - [Routing](Documentation/ROUTING_DOCUMENTATION.md) 
- 🔬 [Running the tests](#running-the-tests-)
- ☀️ [Dependencies](#dependencies-%EF%B8%8F)
- 🤖 [Versioning](#versioning-)
- 🛣 [Roadmap](#roadmap-)
- 👨‍💻 [Authors](#authors-)
- 📄 [License](#license-)

### Synopsis 📋

CoreNavigation is a Swift wrapper around iOS navigation.

### Motivation ✊

Apple provided us with simplest possible API to achive navigation between view controllers. Some apps usually use given APIs directly while other have some wraping logic around them. And that's cool.

But think about the situation where your app has dozens of screens. And you have to support additional features like deep linking and state restoration. CoreNavigation is created to provide developers with cleaner and more powerful APIs to navigate. 🔌

## Getting Started 🚀

These instructions will help you integrate CoreMapping into your project.

### Prerequisities

- Xcode 9 or higher
- iOS 8 or higher
- Cocoapods

### Installing

Add following lines to your `Podfile`

```ruby
pod 'CoreNavigation'
pod 'CoreNavigation/Routing' # for routing capabilities
```

and run 

```bash
$ pod install
```

Cocoapods will fetch and integrate CoreNavigation.

## Example Use 💻

### Basic examples

#### Presenting view controller:

```swift
present { $0
    .to(MyViewController())
}
```

#### Pushing view controller:

```swift
push { $0
    .to(MyViewController())
}
```

#### Routing:

##### Defining view controller

```swift
class UserProfileViewController: UIViewController, DataReceivingViewController {
    typealias DataType = User

    func didReceiveData(_ data: User) {
        // configure UI with data
    }
}
```

##### Defining route

```swift
struct UserProfile: Route, RoutePatternsAware {
    typealias Destination = UserProfileViewController

    let userId: String
    
    var parameters: [String : Any]? {
        return [
            "userId":self.userId
        ]
    }

    /*-------- routing part --------*/
    
    static var patterns: [String] = [
        "https://myapp.com/user/:userId(.*)"
    ]
    
    static func route(handler: RouteHandler<UserProfile>) {
        let userId = handler.parameters?["userId"] as? String
        
        // e.g. fetch user from network
        fetchUser(userId, completion: { (user: User) in
            // notify handler
            handler.complete(data: user)
        })
    }
}
```

##### Presenting route

###### Using strong route

```swift
present { $0
    // configure navigation
    .to(UserProfile(userId: "123456")
    .animated(false)
    ...
}
```

*or*

```swift
UserProfile(userId: "123456").present { $0
    // configure navigation
    .animated(false)
    ...
}
```

*or*

```swift
UserProfile(userId: "123456").present()
```

###### Using soft route

```swift
present { $0
    // configure navigation
    .to("https://myapp.com/user/123456")
    .animated(false)
    ...
}
```

*or*

```swift
"https://myapp.com/user/123456".present { $0
    // configure navigation
    .animated(false)
    ...
}
```

*or*

```swift
"https://myapp.com/user/123456".present()
```

##### Getting view controller

###### Using strong route

```swift
UserProfile(userId: "123456").viewController { (viewController: UserProfileViewController) in
    ...
}
```

###### Using soft route

```swift
"https://myapp.com/user/123456".viewController { (viewController: UIViewController) in
    ...
}
```

## API Reference ⌨️

Read [API reference](Documentation/API_REFERENCE.md)

- [Defining destination](Documentation/API_REFERENCE.md#destination-) (view controller to navigate to)
    - [Instance](Documentation/API_REFERENCE.md#passing-instance)
    - [Class](Documentation/API_REFERENCE.md#passing-class)
    - [Routing](Documentation/API_REFERENCE.md#passing-route)
- [Passing data between view controllers](Documentation/API_REFERENCE.md#passing-data-between-view-controllers-)
- [Transitioning](Documentation/API_REFERENCE.md#transitioning-)
    - [Animation](Documentation/API_REFERENCE.md#animation)
    - [Transitioning delegate](Documentation/API_REFERENCE.md#transitioning-delegate)
    - [Completion](Documentation/API_REFERENCE.md#completion)
- [View controller events](Documentation/API_REFERENCE.md#view-controller-events-)
- [Caching](Documentation/API_REFERENCE.md#caching-%EF%B8%8F)
    - [Lifetime protocol](Documentation/API_REFERENCE.md#lifetime-protocol)
- [Protection](Documentation/API_REFERENCE.md#protection-)
- [State restoration](Documentation/API_REFERENCE.md#state-restoration-%EF%B8%8F)
    - [StateRestorationDelegate protocol](Documentation/API_REFERENCE.md#staterestorationdelegate-protocol)
- [Routing](Documentation/ROUTING_DOCUMENTATION.md) 

## Running the tests 🔬

Available in `CoreNavigationTests` target.

## Dependencies ☀️

* **CoreRoute** (optional) - Routing framework written in Swift

## Versioning 🤖

Current release:

- 0.4.0

## Roadmap 🛣

- [x] CoreNavigation foundation
- [x] State restoration handling
- [x] Routing documentation
- [ ] Deep & universal links handling
- [ ] Code documentation
- [ ] Add missing unit tests
- [ ] Define code of conduct

## Authors 👨‍💻

- Aron Balog ([GitHub](https://github.com/aronbalog))

See also the list of [contributors](CONTRIBUTORS.md) who participated in this project.

### Contributing

Please read [Contributing](CONTRIBUTING.md) for details on code of conduct, and the process for submitting pull requests.

## License 📄

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE.md) file for details.
