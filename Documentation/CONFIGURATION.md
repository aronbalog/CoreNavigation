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

| Method                        | Arguments                                 |
| :-----------------------------| :-----------------------------------------|
| [`animated(_:)`]              | `Bool`                                    |

> By passing false, transition will perform without animation. Default: `true`

| Method                        | Arguments                                 |
| :-----------------------------| :-----------------------------------------|
| [`transitioningDelegate(_:)`] | [`UIViewControllerTransitioningDelegate`] |

> Pass the delegate object that provides transition animator, interactive controller, and custom presentation controller objects.

## Observing completion

| Method             | Arguments    |
| :------------------| :------------|
| [`completion(_:)`] | `() -> Void` |

> The block to execute after the navigation finishes (after the `viewDidAppear(_:)` method is called on the presented view controller).

## Observing success

| Method            | Arguments            |
| :-----------------| :--------------------|
| [`onSuccess(_:)`] | [`(Result) -> Void`] |

> TODO: describe usage

## Observing failure

| Method            | Arguments         |
| :-----------------| :-----------------|
| [`onFailure(_:)`] | `(Error) -> Void` |

> TODO: describe usage

## Embedding

| Method                               | Arguments                  |
| :------------------------------------| :--------------------------|
| [`embedded(in:)`][embeddedIn1]       | [`EmbeddingType`]          |
| [`embedded(in:)`][embeddedIn2]       | [`EmbeddingProtocol.Type`] |
| [`embeddedInNavigationController()`] | *None*                     |

> TODO: describe usage

## Passing data

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

| Method                                 | Arguments              |
| :--------------------------------------| :----------------------|
| [`keepAlive(within:cacheIdentifier:)`] | [`Lifetime`], `String` |

> TODO: describe usage

## Protection

| Method             | Arguments           |
| :------------------| :-------------------|
| [`protect(with:)`] | [`ProtectionSpace`] |

> TODO: describe usage

## State restoration

| Method                               | Arguments                                      |
| :------------------------------------| :----------------------------------------------|
| [`stateRestorable()`]                  | *None*                                         |
| [`stateRestorable(identifier:)`]       | `String`                                       |
| [`stateRestorable(identifier:class:)`] | `String`, [`UIViewControllerRestoration.Type`] |

> TODO: describe usage

## Specifying origin view controller

| Method       | Arguments            |
| :------------| :--------------------|
| [`from(_:)`] | [`UIViewController`] |

> TODO: describe usage



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


[`UIViewControllerTransitioningDelegate`]: https://developer.apple.com/documentation/uikit/uiviewcontrollertransitioningdelegate
[`EmbeddingType`]: https://docs.corenavigation.org/Enums/EmbeddingType.html
[`EmbeddingProtocol.Type`]: https://docs.corenavigation.org/Protocols/EmbeddingProtocol.html
[`Lifetime`]: https://docs.corenavigation.org/Protocols/Lifetime.html
[`ProtectionSpace`]: https://docs.corenavigation.org/Protocols/ProtectionSpace.html
[`UIViewControllerRestoration.Type`]: https://developer.apple.com/documentation/uikit/uiviewcontrollerrestoration
[`(Result) -> Void`]: https://docs.corenavigation.org/Classes/Result.html
[`UIViewController`]: https://developer.apple.com/documentation/uikit/uiviewcontroller