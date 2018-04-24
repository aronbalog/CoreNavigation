![](Documentation/Assets/cover-image.png)

# CoreNavigation 📱📲

Navigate between view controllers with ease. 💫

[![Build Status](https://travis-ci.org/aronbalog/CoreNavigation.svg?branch=master)](https://travis-ci.org/aronbalog/CoreNavigation)
[![Platform](https://img.shields.io/cocoapods/p/CoreNavigation.svg?style=flat)](https://github.com/aronbalog/CoreNavigation)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CoreNavigation.svg)](https://img.shields.io/cocoapods/v/CoreNavigation.svg)

## Getting Started 🚀

These instructions will help you integrate CoreMapping into your project.

### Prerequisities

- Xcode 9 or higher
- iOS 8 or higher
- Cocoapods

### Installing

Add following line to your `Podfile`

```ruby
pod 'CoreNavigation', '~> 1.0.0'
```

and run 

```bash
$ pod install
```

## Example Use 💻

### Basic examples

#### Defining view controller

```swift
class UserProfileViewController: UIViewController, DataReceivable {
    typealias DataType = User

    func didReceiveData(_ data: User) {
        // configure UI with data
    }
}
```

#### Presenting view controller:

```swift
Navigate.present { $0
    .to(UserProfileViewController())
    .withData(user)
}
```

#### Pushing view controller:

```swift
Navigate.push { $0
    .to(UserProfileViewController())
    .withData(user)
}
```

#### Routing & deep linking:


- Why using destination?
- Describe destination

##### Defining `Destination`

```swift
struct UserProfile: Destination, Routable {
    typealias ViewControllerType = UserProfileViewController

    static var patterns: [String] = [
        "https://myapp.com/user/:userId(.*)"
    ]
    
    let userId: String
    
    init(_ userId: String) {
        self.userId = userId
    }
    
    var parameters: [String : Any]? {
        return [
            "userId": userId
        ]
    }

    static func resolve(context: Context<MyRoute>) {
        guard let userId = context.parameters?["userId"] as? String else {
            context.cancel()
        }
        
        // fetch your user
        fetchUser(userId: userId, completion: { (user: User) in
            context.complete(data: user)
        }, failure: { (error: Error) in
            context.cancel(error: error)
        })
    }
}
```

##### Navigating

###### Using `Destination`

```swift
Navigate.present { $0
    .to(UserProfile("sherlock_holmes"))
    // configure navigation
    ...
}
```

-----

*or*

```swift
UserProfile("sherlock_holmes").present { $0
    // configure navigation
    ...
}
```

-----

*or*

```swift
UserProfile("sherlock_holmes").present()
```

###### Using route

```swift
present { $0
    .to("https://myapp.com/user/sherlock_holmes")
    // configure navigation
    ...
}
```

-----

*or*

```swift
"https://myapp.com/user/sherlock_holmes".present { $0
    // configure navigation
    ...
}
```

-----

*or*

```swift
"https://myapp.com/user/sherlock_holmes".present()
```

##### Getting view controller

###### Using `Destination`

```swift
UserProfile("sherlock_holmes").viewController { vc in
    // vc is `UserProfileViewController`
}
```

###### Using route

```swift
"https://myapp.com/user/sherlock_holmes".viewController { vc in
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
