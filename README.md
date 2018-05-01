# CoreNavigation 📱📲

Navigate between view controllers with ease. 💫

[![Platform](https://img.shields.io/cocoapods/p/CoreNavigation.svg?style=flat)](https://github.com/aronbalog/CoreNavigation)
[![Build Status](https://travis-ci.org/aronbalog/CoreNavigation.svg?branch=master)](https://travis-ci.org/aronbalog/CoreNavigation)
[![Documentation](docs/badge.svg)](http://aronbalog.github.io/CoreNavigation)
[![codecov](https://codecov.io/gh/aronbalog/CoreNavigation/branch/master/graph/badge.svg)](https://codecov.io/gh/aronbalog/CoreNavigation)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CoreNavigation.svg)](https://img.shields.io/cocoapods/v/CoreNavigation.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

- [Getting Started]
- [API Reference]
- [Example Use]
    - [Defining view controller]
    - [Presenting view controller]
    - [Pushing view controller]
    - [Routing & deep linking]
    - [Configuration]
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
- [Running the Tests]
- [Versioning]
- [Authors]
- [License]

[Getting Started]: #getting-started
[API Reference]: #api-reference
[Example Use]: #example-use
[Defining view controller]: #defining-view-controller
[Presenting view controller]: #presenting-view-controller
[Pushing view controller]: #pushing-view-controller
[Routing & deep linking]: #routing--deep-linking
[Configuration]: #configuration
[Running the Tests]: #running-the-tests
[Versioning]: #versioning
[Authors]: #authors
[License]: #license

## Getting Started

These instructions will help you integrate CoreNavigation into your project.

### Prerequisities

- Xcode 9 or higher
- iOS 8 or higher
- Cocoapods

### Installation

#### CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build CoreNavigation 1.0+.

To integrate CoreNavigation into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
target '<Your Target Name>' do
    use_frameworks!
    
    pod 'CoreNavigation', '1.0.0-beta-1'
end
```

Then, run the following command:

```bash
$ pod install
```

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate CoreNavigation into your Xcode project using Carthage, specify it in your Cartfile:

```
github "aronbalog/CoreNavigation" == "1.0.0-beta-1"
```

## API Reference

### [API reference](https://docs.corenavigation.org)

## Example Use

### Defining view controller:

```swift
class PersonProfileViewController: UIViewController, DataReceivable {

    // DataReceivable associatedtype
    typealias DataType = Person

    func didReceiveData(_ data: Person) {
        // configure UI with data
    }
}
```

### Presenting view controller:

[Code Example](Playgrounds/Presenting.playground/Contents.swift)

```swift
Navigate.present { $0
    .to(PersonProfileViewController())
    .withData(person)
}
```

### Pushing view controller:

[Code Example](Playgrounds/Pushing.playground/Contents.swift)

```swift
Navigate.push { $0
    .to(PersonProfileViewController())
    .withData(person)
}
```

### Routing & deep linking:

Why use the `Destination` instead navigating directly to view controller?

Read about it on Medium:

- [#1 iOS - Reinventing view controller navigation](https://medium.com/@aronbalog/1-ios-reinventing-view-controller-navigation-c2745b60bb6c)
- [#2 iOS - Reinventing view controller navigation](https://medium.com/@aronbalog/2-ios-reinventing-view-controller-navigation-8d2adee8e424)

#### Defining `Destination`

[Code Example](Playgrounds/Routing.playground/Contents.swift)

```swift
struct PersonProfile: Destination, Routable {

    // Destination associatedtype
    typealias ViewControllerType = PersonProfileViewController

    // Routable patterns
    static var patterns: [String] = [
        "https://myapp.com/person/:personId(.*)",
        "https://myapp.com/user/:personId(.*)"
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

---

#### Registering `Routable` types

In order to use `Matchable` types (`String`, `URL`, etc.) to navigate, every `Destination` type must be registered. Think about it as internal DNS.

```swift
PersonProfile.register()
```

<details>
<summary>Additional syntax</summary>

```swift
Navigate.router.register(routableType: PersonProfile.self)
```

</details>

---

`Destination` type can be routable without conforming to `Routable` protocol. Use this if you intend to create some kind of destination manifest and/or if route patterns are fetched from an external source:

```swift
Navigate.router.register(destinationType: PersonProfile.self, patterns: [
    "https://myapp.com/person/:personId(.*)",
    "https://myapp.com/user/:personId(.*)"
])
```

<details>
<summary>Additional syntax</summary>

```swift
PersonProfile.self <- [
    "https://myapp.com/person/:personId(.*)",
    "https://myapp.com/user/:personId(.*)"
]

Settings.self <- [
    "https://myapp.com/settings"
]
```

</details>

---

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

<details>
<summary>Additional syntax</summary>

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

</details>

<details>
<summary>Additional syntax</summary>

```swift
// present
PersonProfile("sherlock_holmes").present()

// or push
PersonProfile("sherlock_holmes").push()
```

</details>

---

#### Navigating using route

[Code Example](Playgrounds/Routing.playground/Contents.swift)

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

<details>
<summary>Additional syntax</summary>

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

</details>

<details>
<summary>Additional syntax</summary>

```swift
// present
"https://myapp.com/person/sherlock_holmes".present()

// or push
"https://myapp.com/person/sherlock_holmes".push()
```

</details>

---

#### Getting view controller asynchronously using `Destination`

```swift
PersonProfile("sherlock_holmes").viewController { (viewController) in
    // vc is `PersonProfileViewController`
}
```

---

#### Getting view controller asynchronously using route

```swift
"https://myapp.com/person/sherlock_holmes".viewController { (viewController) in
    ...
}
```

---

#### Getting view controller synchronously using `Destination`

[Code Example](Playgrounds/Routing.playground/Contents.swift)

```swift
do {
    let viewController = try PersonProfile("sherlock_holmes").viewController()
} catch let error {
    // handle error
}
```

---

#### Getting view controller synchronously using route

```swift
do {
    let viewController = try "https://myapp.com/person/sherlock_holmes".viewController()
} catch let error {
    // handle error
}
```

Note:

*If you implement custom destination resolving, **it must happen on the main thread**; otherwise, an error is thrown.*

---

#### Matchable protocol

`URL` types can also be used to navigate or resolve view controller. Actually, any type conforming `Matchable` protocol can be used.

##### Conforming to matchable:

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

##### Example usage:

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

### Configuration

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

## Running the Tests

Available in `CoreNavigationTests` target.

## Versioning

Current release:

- 1.0.0-beta-3

## Authors

- Aron Balog - [GitHub](https://github.com/aronbalog) | [Twitter](https://twitter.com/Aron_Balog) | [LinkedIn](https://www.linkedin.com/in/aronbalog/) | [Medium](https://medium.com/@aronbalog)

### Contributing

Please read [Contributing](CONTRIBUTING.md) for details on code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE.md) file for details.


[Animating]: Documentation/CONFIGURATION.md#animating
[Observing completion]: Documentation/CONFIGURATION.md#observing-completion
[Observing success]: Documentation/CONFIGURATION.md#observing-success
[Observing failure]: Documentation/CONFIGURATION.md#observing-failure
[Embedding]: Documentation/CONFIGURATION.md#embedding
[Passing data]: Documentation/CONFIGURATION.md#passing-data
[Caching]: Documentation/CONFIGURATION.md#caching
[Protection]: Documentation/CONFIGURATION.md#protection
[State restoration]: Documentation/CONFIGURATION.md#state-restoration
[Specifying origin view controller]: Documentation/CONFIGURATION.md#specifying-origin-view-controller