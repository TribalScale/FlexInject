# FlexInject

A small but flexible Dependency Injection library for swift.

## Installation

To install the `FlexInject` package through Swift Package Manager(SPM):

1. Open Xcode
2. Go to File -> Add Packages
3. On top right search bar, search for URL: https://github.com/TribalScale/FlexInject.git
4. Add the package

## Features

`FlexInject` helps with property style dependency injection using `propertWrapper`s to perform the injection. `FlexInject` uses a shared or custom container in order to acheive the final Dependency Injection.

### Basic Usage

`FlexInject` has a shared container on the `DependencyContainer` class in order to `register` our dependencies. To do so we simply call the `register` method.

```swift
DependencyContainer.shared.register(type: NetworkService.self) {
  return NetworkService()
}
```

In order to retreive the dependency simply call the `resolve` method

```swift
let dependency = DependencyContainer.shared.resolve(type: NetworkService.self)
```

### `@Inject`

`@Inject` is a `propertyWrapper` that can be used to `resolve` the dependency to a property. After you have registered your dependency, you can add the `propertyWrapper` to a property for it to be resolved.

```swift
class ClassWithAResolvedProperty {
  @Injected
  let networkService: NetworkService
}
```

That is all that is required to get the dependency from the `shared` instance of the container.

### `@LazyInject`

`@LazyInject` is a `propertyWrapper` that is used to resolve the dependency using a lazy property. It will delay the resolving until the property is first accessed.

```swift
class ClassWithAResolvedProperty {
  @LazyInject
  let networkService: NetworkService
}
```

The first time you use the `networkService` it will call into the container and retreive the instance.

### `@WeakInject`

`@WeakInject` is a `propertyWrapper` that is used to resolve the dependency using a weak property. It will hold a weak reference to the property allowing it to fall out of memory when the dependency is removed from the container.

```swift
class ClassWithAResolvedProperty {
  @WeakInject
  let networkService: NetworkService?
}
```

## Advanced usage

All the `propertyWrapper`s can take in specific `String` `key`, custom containers, and a `ResolveMode` for shared/new.

### Key

Instead of using `register` for dependencies based on their types, we can also `register` based on a String `key`. This allows us to register multiple dependencies of the same type.

```swift
DependencyContainer.shared.register(key: "NetworkService") {
  NetworkService()
}
```

It can then be resolved with any of the following:

```swift
let networkService: NetworkService = DependencyContainer.shared.resolve(key: "NetworkService")

@Inject(key: "NetworkService")
var networkService: NetworkService
@LazyInject(key: "NetworkService")
var networkService: NetworkService
@WeakInject(key: "NetworkService")
var networkService: NetworkService?
```

### Custom Container

You can pass in your own container to the `propertyWrapper` as well. This will allow you to have multiple containers.

```swift
let container: DIContainer = DependencyContainer()
container.register(type: NetworkService.self) {
  return NetworkService()
}

let networkService = container.resolve(type: NetworkService.self)

@Inject(container: container)
var networkService: NetworkService
@LazyInject(container: container)
var networkService: NetworkService
@WeakInject(container: container)
var networkService: NetworkService?
```

### `ResolveMode`

This mode allows you to either request a `shared` or `new` instance of the dependency. Each mode will do the following:

- `new` - Rerun the closure to return a new instance of the dependency
- `shared` - Create an instance using the closure and then return that dependency in the future to anyone else requesting the `shared` instance.

```swift
let networkService = DependencyContainer.shared.resolve(type: NetworkService.self, mode: .new)

@Inject(mode: .new)
var networkService: NetworkService
@LazyInject(mode: .shared)
var networkService: NetworkService
@WeakInject(mode: .new)
var networkService: NetworkService?
```

Note: Using the `@WeakInject` and the `ResolveMode.new` will mean that you will need to manage the non-weak reference of the object. Of course that is the nature of the `weak` type.

## Unit Testing

In order to unit test with this framework, you simply register your mock dependencies in place of the real ones.

```swift
DependencyContainer.shared.register(type: NetworkService.self) {
  return MockNetworkService()
}
```

This will now resolve the dependency in the class you are testing to the mock instance of your `NetworkService`.

## More Info

For more information on how this library was made, check out my blog post [here](https://google.ca)
