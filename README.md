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
- 🔬 [Running the tests](#running-the-tests-)
- ☀️ [Dependencies](#dependencies-%EF%B8%8F)
- 🤖 [Versioning](#versioning-)
- 👨‍💻 [Authors](#authors-)
- 📄 [License](#license-)

### Synopsis 📋

CoreNavigation is a Swift wrapper around iOS navigation.

### Motivation ✊

Apple provided us with simplest possible API to achive navigation between view controllers. Some apps usually use given APIs directly while other have some wraping logic around them. And that's cool.

But think about the situation where your app has dozens of screens. And you have to support additional features like deep linking and state restoration on all of them? CoreNavigation is created to provide developers with cleaner and more powerful APIs to navigate. 🔌

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

Basic examples:

#### Presenting view controller

```swift
Navigation.present { navigate in    
    navigate.to(MyViewController.self)
}
```

#### Presenting view controller embedded in navigation controller

```swift
Navigation.present { $0    
    .to(MyViewController.self)
    .embed(in: UINavigationController.self)
}
```

#### Pushing view controller

```swift
Navigation.push { navigate in    
    navigate.to(MyViewController.self)
}
```

## API Reference ⌨️

Read [API reference](Documentation/API_REFERENCE.md)

- 📲 [Defining destination](Documentation/API_REFERENCE.md#destination-) (view controller to navigate to)
    - [Instance](Documentation/API_REFERENCE.md#passing-instance)
    - [Class](Documentation/API_REFERENCE.md#passing-class)
    - [Routing](Documentation/API_REFERENCE.md#passing-route)
- 📡 [Passing data between view controllers](Documentation/API_REFERENCE.md#passing-data-between-view-controllers-)
- 🎞 [Transitioning](Documentation/API_REFERENCE.md#transitioning-)
    - [Animation](Documentation/API_REFERENCE.md#animation)
    - [Transitioning delegate](Documentation/API_REFERENCE.md#transitioning-delegate)
    - [Completion](Documentation/API_REFERENCE.md#completion)
- 🎯 [View controller events](Documentation/API_REFERENCE.md#view-controller-events-)
- ♻️ [Caching](Documentation/API_REFERENCE.md#caching-%EF%B8%8F)
    - [Lifetime protocol](Documentation/API_REFERENCE.md#lifetime-protocol)
- 👮 [Protection](Documentation/API_REFERENCE.md#protection-)
    
## Running the tests 🔬

Available in `CoreNavigationTests` target.

## Dependencies ☀️

* **CoreRoute** (optional) - Routing framework written in Swift

## Versioning 🤖

Current release:

- 0.1.5

## Authors 👨‍💻

- Aron Balog - [Github](https://github.com/aronbalog)

See also the list of [contributors](CONTRIBUTORS.md) who participated in this project.

### Contributing

Please read [Contributing](CONTRIBUTING.md) for details on code of conduct, and the process for submitting pull requests.

## License 📄

This project is licensed under the **MIT License** - see the [LICENSE.md](LICENSE.md) file for details.
