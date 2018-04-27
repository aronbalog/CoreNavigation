![](Documentation/Assets/cover-image.png)

# CoreNavigation 📱📲

Navigate between view controllers with ease. 💫

[![Build Status](https://travis-ci.org/aronbalog/CoreNavigation.svg?branch=master)](https://travis-ci.org/aronbalog/CoreNavigation)
[![Platform](https://img.shields.io/cocoapods/p/CoreNavigation.svg?style=flat)](https://github.com/aronbalog/CoreNavigation)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CoreNavigation.svg)](https://img.shields.io/cocoapods/v/CoreNavigation.svg)

## Getting Started 🚀

These instructions will help you integrate CoreNavigation into your project.

### Prerequisities

- Xcode 9 or higher
- iOS 8 or higher
- Cocoapods

### Installing

Add following line to your `Podfile`

```ruby
pod 'CoreNavigation', '~> 1.0'
```

and run 

```bash
$ pod install
```

## Example Use 💻

### Basic examples

#### Defining view controller:

```swift
class PersonProfileViewController: UIViewController, DataReceivable {

    // DataReceivable associatedtype
    typealias DataType = Person

    func didReceiveData(_ data: Person) {
        // configure UI with data
    }
}
```

#### Presenting view controller:

```swift
Navigate.present { $0
    .to(PersonProfileViewController())
    .withData(person)
}
```
[Playground example](Playgrounds/Presenting.playground)

#### Pushing view controller:

```swift
Navigate.push { $0
    .to(PersonProfileViewController())
    .withData(person)
}
```
[Playground example](Playgrounds/Pushing.playground)

### Routing & deep linking:


- TODO: Describe why use the `Destination`?
- TODO: Describe `Destination`
- TODO: External `Destination` examples

#### Defining `Destination`

```swift
struct PersonProfile: Destination, Routable {

    // Destination associatedtype
    typealias ViewControllerType = PersonProfileViewController

    // Routable patterns
    static var patterns: [String] = [
        "https://myapp.com/person/:personId(.*)"
    ]
    
    let personId: String
    
    init(_ personId: String) {
        self.personId = personId
    }
    
    var parameters: [String : Any]? {
        return [
            "personId": personId
        ]
    }

    static func resolve(context: Context<PersonProfile>) {
        guard let personId = context.parameters?["personId"] as? String else {
            // cancel navigation with some error
            context.cancel(error: NavigationError.Destination.notFound)
            return
        }
        
        // fetch person
        fetchPerson(id: personId, completion: { (person: Person) in
            // continue to navigation
            context.complete(data: person)
        }, failure: { (error: Error) in
            // cancel navigation with some error
            context.cancel(error: error)
        })
    }
}
```

#### Navigating using `Destination`

```swift
// present
Navigate.present { $0
    .to(PersonProfile("sherlock_holmes"))
    ...
}

// or push
Navigate.push { $0
    .to(PersonProfile("sherlock_holmes"))
    ...
}
```

*Additional syntax*

```swift
// present
PersonProfile("sherlock_holmes").present { $0
    ...
}

// or push
PersonProfile("sherlock_holmes").push { $0
    ...
}
```

*Additional syntax*

```swift
// present
PersonProfile("sherlock_holmes").present()

// or push
PersonProfile("sherlock_holmes").push()
```

[Playground example](Playgrounds/Routing.playground)

#### Navigating using route

```swift
// present
Navigate.present { $0
    .to("https://myapp.com/person/sherlock_holmes")
    ...
}

// or push
Navigate.push { $0
    .to("https://myapp.com/person/sherlock_holmes")
    ...
}
```

*Additional syntax*

```swift
// present
"https://myapp.com/person/sherlock_holmes".present { $0
    ...
}

// or push
"https://myapp.com/person/sherlock_holmes".push { $0
    ...
}
```

*Additional syntax*

```swift
// present
"https://myapp.com/person/sherlock_holmes".present()

// or push
"https://myapp.com/person/sherlock_holmes".push()
```

[Playground example](Playgrounds/Routing.playground)

#### Getting view controller asynchronously using `Destination`

```swift
PersonProfile("sherlock_holmes").viewController { (viewController) in
    // vc is `PersonProfileViewController`
}
```

#### Getting view controller asynchronously using route

```swift
"https://myapp.com/person/sherlock_holmes".viewController { (viewController) in
    ...
}
```

#### Getting view controller synchronously using `Destination`

```swift
do {
    let viewController = try PersonProfile("sherlock_holmes").viewController()
} catch let error {
    // handle error
}
```

[Playground example](Playgrounds/Routing.playground)

#### Getting view controller synchronously using route

```swift
do {
    let viewController = try "https://myapp.com/person/sherlock_holmes".viewController()
} catch let error {
    // handle error
}
```

Note:

*If you implement custom destination resolving, **it must happen on the main thread**; otherwise, an error is thrown. Read about resolving.*

- TODO: Set link to resolving

-----

#### Matchable protocol

`URL` types can also be used to navigate or resolve view controller. Actually, any type conforming `Matchable` protocol can be used.

Example:

```swift
struct Person {
    let id: String
    ...
}

extension Person: Matchable {
    var uri: String {
        return "https://myapp.com/person/" + id
    }
}
```

Example usage:

```swift
let person: Person = Person(id: "sherlock_holmes", ...)

// getting view controller
let personProfileViewController = try! person.viewController

// or navigating
person.present()
person.push()

// or more configurable syntax
Navigate.present { $0
    .to(person)
    ...
}
```
<!---
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

-->

## Running the tests 🔬

Available in `CoreNavigationTests` target.

## Versioning 🤖

Current release:

- 1.0.0

## Authors 👨‍💻

- Aron Balog ([GitHub](https://github.com/aronbalog))

See also the list of [contributors](CONTRIBUTORS.md) who participated in this project.

### Contributing

Please read [Contributing](CONTRIBUTING.md) for details on code of conduct, and the process for submitting pull requests.

## License 📄

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE.md) file for details.
