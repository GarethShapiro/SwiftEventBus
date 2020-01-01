# SwiftEventBus
## A simple Event Bus written in Swift

### Introduction

An Event Bus is an architectural pattern in which _events_ are _dispatched_ and subsequently _consumed_.   As these two things can happen in different places in an application this approach  promotes highlighly decoupled design.

This is a very simple version. It's not asynconous, it's based on dynamic dispatch and relies on a number of easy wins, like conformance to _NSObjectProtocol_ as a shortcut to `Equatable`.

You would consider an Event Bus where flexibilty is more important than performance. 

### Advantages

* Very flexibile
* Promotes decoupling
* Promotes encapsulation
* Easy to create circular data flow

### Disadvantages

* Performance
* The order things are executed is depedant on the order the `EventConsumer`s are registered, and that might not be what you need 
* Can get confusing if you are not careful, or neglect to use a logger

### What kind of things are Event Buses good for?

* Prototypes
* Routing
* Analytics
* Logging

### How does it work?

The example application is a great place to illustrate how it works.  This trivial application has three screens and once the user has navigated to screen #3 they qualify to win a prize and are shown a _call to action_.  This stays in place while they navigate about and once it has been clicked it never returns.

### The Basics

Take a look at `AppDelegate`'s intialiser.

```swift
// MARK: - Lifecycle
override init() {

    self.eventBus = EventBus()
    self.flowController = FlowController(eventBus: eventBus)

    super.init()

    registerEventConsumers()
}
```

An `EventBus` is simply created and injected into the `FlowController`.  This happens quite a bit, the `EventBus` is injected so that other Actors don't have to be.  There is an example of this in `FlowController` itself.  
```swift
// MARK: - Screen Factory
private func createViewController(for destination: Destination) -> UIViewController {
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

In this app screens use the `EventBus` to navigate the user to another screen.  For eg. `ScreenOne` has a button that the user taps to see `ScreenTwo`.  The button tap handler looks like this.
```swift
// MARK: - Button
@objc func handleButtonTap(sender: UIControl) {
    let event = NavigationEvent(destination: .screenTwo)
    eventBus.dispatch(event)
}
```
All that happens is an `Event` is created and dispatched. Job done.  The  `ScreenOne` isn't involved in any of the logic needed to get `ScreenTwo` on the screen, this is of course the job of the `FlowController`.  

How is the event being dispatched by `ScreenOne` intercepted by `FlowController`?  Well `FlowController` is an `EventConsumer` and has registered with the `EventBus`.  Take a look back in `AppDelegate`.

```swift
// MARK: - EventBus
private func registerEventConsumers() {
    let eventConsumers: [EventConsumer] = [model, flowController, Logger(), AnalyticsMediator()]
    for consumer in eventConsumers { eventBus.register(consumer) }
}
```

In this method four `EventConsumer`s are registred with the `EventBus` and one of them is an instance of the `FlowController`.  Conformance to `EventConsumer` requires that the following two properties and one method are provided (there is a default implementation for `excludeList`) :

```swift
var willConsume: [Event.Type] { get }
var excludeList: [Event.Type] { get }
func consume(_ event: Event) -> Void
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

That is essentially how it works.  There are some handy `Event`s built in that are worth mentioning :

- `AllEvent`
- `NoEvent`
- `DidConsumeEvent` (see _Uses in large applications_ below)

`AllEvent` & `NoEvent` can be used on the `willConsume` and `excludeList` in various combinations.  For eg.  An `EventConsumer` can subscribe to all events by adding `AllEvent` to it's `willConsume` list apart from `FooEvent` which it adds to it's `excludeList`.

### Decoupling

Take a look at the three `UIViewController` subclasses, `ScreenOne`, `ScreenTwo` and `ScreenThree` - they are simply concerned with the view and `user interactions` are dispatched for another part of the application to be concerned about.

### Flexibility

On `ScreenThree` there is an _Ok_ button and when the user taps they go back to `ScreenTwo`, to change this target destination to `ScreenOne` the button tap handler in `ScreenThree` needs to be changed to reference the `.screenOne` in the dispatched `NavigationEvent`.

```swift
// MARK: - Button
@objc func handleOkButtonPress(sender: UIControl) {
    let event = NavigationEvent(destination: .screenOne)
    eventBus.dispatch(event)
}
```

Similarly if the screen that the `userRewardCTA` appears on is to change then that screen should dispatch `UserRewardPageViewEvent` and `ScreenThree` dispatch a `PageViewEvent` instead, it's as simple as that.

### Circular Data Flow

By _Circular Data Flow_ I mean data flowing from the `View/Controller` layer to the `Model` and back again. Using `EventBus` this can be achieved without too much congnitive load, or messy code.

In the example app the _call to action_ view is mediated by the `FlowController` alongside a `UINavigationController` which does the navigating (disclaimer: trivial example app)!  When the user taps on it to claim their prize the `FlowController` dispatches an `UserClaimRewardEvent.`

```swift
// MARK: - Button Events
@objc func handleUserRewardCTATap(sender: UIControl) {
    let event = UserClaimRewardEvent()
    eventBus.dispatch(event)
}
```

This is consumed on the `Model` which updates the state of the application and dispatches an event informing any `EventConsumer`s about this state change dispatching `RewardClaimedStateEvent`.  In this example the consumer is the `FlowController` which hides the _call to action_.

### Encapsulation

All of the business logic needed to handle the _call to action_ state is contained, apart from a property initialisation, in one switch statement on the `Model`.

```swift
func consume(_ event: Event) {
    switch(event) {
    case is UserRewardPageViewEvent:

        if userHasClaimedPrize == false {
            let event = UserQualifiedForRewardEvent()
            eventBus.dispatch(event)
        }

    case is UserClaimRewardEvent:

        userHasClaimedPrize = true
        let event = RewardClaimedStateEvent()
        eventBus.dispatch(event)

    default:break
    }
}
```
The logic required to show and hide the _call to action_ is also neatly contained on the `FlowController`.

```swift
func consume(_ event: Event) {
    ...
    case is UserQualifiedForRewardEvent:
        showPrizeUI()
    case is RewardClaimedStateEvent:
        hidePrizeUI()
    ...
}
```

Note also that the event names are, for the most part, abstract from their side effects in the application, eg.  There is no `HideCTAUIEvent` or `ShowCTAUIEvent`.
This is reasonable architecture if you are doing things quickly, wanting to iterate often and expect many things to change, or if you are making a small app.  Bare in mind it's not going to be the most performant, flexibilty usually comes with a performance penalty, and an Event Bus is no different.

###  Uses in large applications

Even in high performing applications there may be parts of the system where you might chose to priortitise flexibilty over speed and the of Event Buses can be useful.

I have imlemented a simple router here and also included two examples of how sub systems can be based on an Event Bus:

1. Analytics
2. Logging

Both of these application aspects suffer the same characteristic, _they want to go everywhere_.  An Event Bus offers an alternative where it can go everywhere instead and not only do more than one job but just as demonstrated above provide an abstraction away from the analytics being collected or items being logged.

While they are naive implementations here both `AnalyticsMediator` and `Logger` are very straight forward.  Every `UIViewController` subclass dispatches a `PageViewEvent` in its `viewDidAppear` method which is consumed by  `AnalyticsMediator`.  This is where interating with a specific vendor's SDK can happen.  Should you wish to change your analytics provider (anyone?) then this is encapsulated by (or behind) the `AnalyticsMediator`.   You may be collecting more than one type of analytics (anyone anyone?) in which case more than one `EventConsumer` can consume the same `Event`. 

The `Logger` is even more straight forward.  It consumes `DidConsumeEvent`s which are automatically dispatched by `EventBus` after each `EventConsumer` `consumes` an `Event`.  These carry a payload which includes details of who consumed what and this can be logged, here simply to the console.  It would be trivial to register a different type of logging mechanism based on configuration at application start and logging messages could instead be routed elsewhere.
