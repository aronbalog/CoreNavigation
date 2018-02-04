# Routing

To use routing capabilities add following lines to your Podfile

```ruby
pod 'CoreNavigation/Routing'
```

and run 

```bash
$ pod install
```

## Simple routing

Used in cases when passing parameters to destination view controller is not needed.

#### Defining a route:

1. Import `CoreRoute` module
2. Define a type with an arbitrary name and conform it to `Route` protocol
3. `Route` protocol will ask you to provide the following properties:
    - `static var destination: Any?`
    - `static var routePattern: String`


```swift
import CoreRoute

struct Home: Route {    
    static var destination = HomeViewController.self    
    static var routePattern = "home"
}
```

#### Registering a route:


```swift
Navigation.router.register(routeType: Home.self)
```


#### Navigating to route:

```swift
import CoreNavigation

Navigation.present { (present) in
    present.to(Home())
}
```

## Advanced routing

Used in cases when some parameters should be passed to destination view controller.

If your view controller has custom `init` you would implement:

```swift
import CoreRoute

struct UserProfile: Route {    
    static var routePattern: String = "user/<id>"
    
    static var destination: UserProfileViewController? = nil
    
    let id: String
    
    var routePath: String {
        return "user/" + self.id
    }
    
    // implement following method if view controller has custom init
    static func buildDestination(parameters: [String: Any]?) -> Any? {
        guard let id = parameters?["id"] as? String else { return nil }
        
        return UserProfileViewController(userId: id)
    }
    
    // implement following method if you want to transform path parameters to parameters
    // which will be sent to `didReceiveResponse(_:)` from `ResponseAware` protocol
    static func buildParameters(with pathParameters: [String: Any]?) -> [String: Any]? {
        guard let id = pathParameters?["id"] as? String else { return pathParameters }
        
        let user = User(id: id)
        
        return [
            "user": user
        ]
    }
}
```

#### Registering a route:

```swift
Navigation.router.register(routeType: UserProfile.self)
```

#### Navigating to route:

```swift
import CoreNavigation

Navigation.present { (present) in
    present.to(UserProfile(id: "user_765"))
}
```

## Abstract routing

Sometimes an access to route types is unavailable, e.g. in multiple frameworks project where one framework cannot see another. However, you can still use route paths as a reference in navigation. Every `Route` is also `AbstractRoute` which means that every route have it's own route path and route pattern string. Those strings actually identifies route under the hood in the matching proccess.

#### Navigating to abstract route:

```swift
import CoreNavigation

Navigation.present { (present) in
    present.to("user/user_765")
}
```

Previous example have the same effect as the one in [Advanced routing](#advanced-routing) section.