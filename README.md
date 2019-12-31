# SwiftEventBus
## A simple Event Bus written in Swift

### Introduction

An Event Bus is an architectural pattern in which Events are _dispatched_ and subsequently _consumed_.   As these two things can happen in different places in an application this approach can promote highlighly decoupled design.

This is a very simple version, there is no concurrency, it's all based on dynamic dispatch and uses a number of short cuts, like conformance to _NSObjectProtocol_ as a shortcut 

### Advantages

* Promotes decoupling
* Promotes encapsulation
* Very flexibile
* Promotes circular data flow th

### Disadvantages

* Not high performance
* The order things are executed is depedant on the order the _EventConsumer_s are registered, and that might not be what you need 

### What kind of things are Event Buses good for?

* Prototypes
* Routing
* Analytics

### How does it work?

The example application is a great place to illustrate how it works.  This simple application has three screens and once the user has navigated to Screen #3 they qualify to win a prize and are show a call to action.  This stays in place while they navigate about and once it has been clicked it never returns.  Simple enough, it's just an example to show how the `EventBus` works really.

### The Basics

Take a look at `AppDelegate`'s intialiser.

```swift
override init() {
    eventBus = EventBus()
    flowController = FlowController(eventBus: eventBus)

    super.init()

    registerEventConsumers()
}
```

An `EventBus` is simply created and injected into the `FlowController`, this happens quite a bit.  The `EventBus` is injected so that other Actors don't have to be.  There is an example of this in `FlowController` itself.  
```swift
// MARK: - Screen Factory
private func createViewControler(for destination: Destination) -> UIViewController {
    switch destination {
    case .screenOne:
        return ScreenOne(eventBus: eventBus)
    case .screenTwo:
        return ScreenTwo(eventBus: eventBus)
    case .screenThree:
        return ScreenThree(eventBus: eventBus)
    }
}
```

These screens use the `EventBus` to navigate the user to another screen.  `ScreenOne` has a button that the user taps to see `ScreenTwo`.  The button tap handler looks like this.
```swift
// MARK: - Button
@objc func handleButtonTap(sender: UIControl) {
    let event = NavigationEvent(destination: .screenTwo)
    eventBus.dispatch(event)
}
```
All that happens is an Event is created and dispatched. Job done.  The  `ScreenOne` isn't involved in any of the logic needed to get `ScreenTwo` on the screen, this is of course the job of the `FlowController`.  How is the event being dispatched `ScreenOne` intercepted by `FlowController`?  Well `FlowController` is an `EventConsumer` and has registered with the `EventBus`.  Take a look back in `AppDelegate`.

```swift
// MARK: - EventBus
private func registerEventConsumers() {
    let eventConsumers: [EventConsumer] = [model, flowController, Logger(), AnalyticsMediator()]
    for consumer in eventConsumers { eventBus.register(consumer) }
}
```

In this method four `EventConsumer`s are registred with the `EventBus` and one of them is an instance of the `FlowController`.  This conformance requires that the following two properties and one methods are provided (there is a default implementation for `excludeList`):

```swift
var willConsume: [Event.Type] { get }
func consume(_ event: Event) -> Void
var excludeList: [Event.Type] { get }
```

`FlowController` implements these like so:
```swift
// MARK: - EventConsumer
var willConsume: [Event.Type] {
    return [NavigationEvent.self, ShowUserRewardEvent.self, HideUserRewardEvent.self]
}

func consume(_ event: Event) {
    switch event {
    case let navigationEvent as NavigationEvent:
        navigateTo(navigationEvent.destination)
    case is ShowUserRewardEvent:
        showPrizeUI()
    case is HideUserRewardEvent:
        hidePrizeUI()
    default: break;
    }
}
```

First the types of Events that an `EventConsumer` `willConsume` are listed and then `consume` will be called when one of these is dispatched onto the `EventBus`.

That is essentially how it works.  You can see how _decoupling_ is promoted this way.  Take a look at the three `UIViewController` subclasses, they simply concerned with the view and all user interactions are dispatched for another part of the application to be concerned about.

Another advantage listed earlier is _flexibility_.  On `ScreenThree` there is an _Ok_ button and when the user taps they go back to `ScreenTwo`, to change this to `ScreenOne` the button tap handler in `ScreenThree` needs to be changed to reference the `.screenOne` in the destination.

```swift
// MARK: - Button
@objc func handleOkButtonPress(sender: UIControl) {
    let event = NavigationEvent(destination: .screenOne)
    eventBus.dispatch(event)
}
```
