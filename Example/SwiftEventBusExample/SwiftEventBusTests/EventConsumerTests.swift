//
//  EventConsumerTests.swift
//  SwiftEventBusTests
//
//  Created by Gareth Shapiro on 31/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import XCTest
import SwiftEventBus

class EventConsumerTests: XCTestCase {

    // AllEvent on willConsume overrides missing events on willConsume
    func testWillConsumeAllEvent() {

        // GIVEN an EventConsumer which includes the AllEvent as an item in the willConsume array
        // AND this EventConsumer is registered with an EventBus
        // WHEN events not included in the EventConsumers willConsume array are dispatched on the EventBus
        // THEY are consumed by the EventConsumer
        let stubEventBus = EventBus()
        let stubEventConsumer = StubWillConsumeAllEventEventConsumer()
        stubEventBus.register(stubEventConsumer)

        let stubEvent = StubEvent()
        stubEventBus.dispatch(stubEvent)
        XCTAssertTrue(check(stubEvent, consumedBy: stubEventConsumer) , "EventConsumer.consume was not called or not called with the correct Event : \(stubEvent.self)")

        let anotherStubEvent = AnotherStubEvent()
        stubEventBus.dispatch(anotherStubEvent)
        XCTAssertTrue(check(anotherStubEvent, consumedBy: stubEventConsumer) , "EventConsumer.consume was not called or not called with the correct Event : \(anotherStubEvent.self)")
    }

    // NoEvent on willConsume overrides other events on willConsume
    func testWillConsumeNoEvent() {

        // GIVEN an EventConsumer which includes the NoEvent as an item in its willConsume array
        // AND this EventConsumer includes other events as items in its willConsume array
        // AND is registered with an EventBus
        // WHEN any of the other events included in the EventConsumers willConsume array are dispatched on the EventBus
        // THEY are not consumed by the EventConsumer
        let stubEventBus = EventBus()
        let stubEventConsumer = StubWillConsumeNoEventEventConsumer()
        stubEventBus.register(stubEventConsumer)

        let stubEvent = StubEvent()
        stubEventBus.dispatch(stubEvent)
        XCTAssertFalse(stubEventConsumer.consumeWasCalled , "EventConsumer.consume was called unexpectedly")

        let anotherStubEvent = AnotherStubEvent()
        stubEventBus.dispatch(anotherStubEvent)
        XCTAssertFalse(stubEventConsumer.consumeWasCalled , "EventConsumer.consume was called unexpectedly")
    }

    // NoEvent overrides AllEvent on willConsume
    func testNoEventPrecedence() {

        // GIVEN an EventConsumer which includes the NoEvent and AllEvent as items in its willConsume array
        // AND it is registered with an EventBus
        // WHEN any events are dispatched on the EventBus
        // THEY are not consumed by the EventConsumer
        let stubEventBus = EventBus()
        let stubEventConsumer = StubWillConsumeNoAndAllEventEventConsumer()
        stubEventBus.register(stubEventConsumer)

        let stubEvent = StubEvent()
        stubEventBus.dispatch(stubEvent)
        XCTAssertFalse(stubEventConsumer.consumeWasCalled , "EventConsumer.consume was called unexpectedly")

        let anotherStubEvent = AnotherStubEvent()
        stubEventBus.dispatch(anotherStubEvent)
        XCTAssertFalse(stubEventConsumer.consumeWasCalled , "EventConsumer.consume was called unexpectedly")
    }

    // Event on excludeList overrides same event on willConsume
	func testExcludeListWithWillConsumeEvent() {

		// GIVEN a registered EventConsumer which includes a specific Event on its excludeList
		// AND this Event is an item on its willConsume list
		// WHEN this Event is dispatched on the EventBus
		// THEN the EventConsumer does not consume this Event
		let stubEventConsumer = ExcludeWillConsumeStubEventConsumer()
		let eventBus = EventBus()
		let stubEvent = StubEvent()

		eventBus.register(stubEventConsumer)
		eventBus.dispatch(stubEvent)

		XCTAssertFalse(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was unexpectedly called.")
	}

    // Event on excludeList not on willConsume is not consumed
	func testExcludeListWithNoWillConsumeEvent() {

		// GIVEN a registered EventConsumer which includes a specific Event on its excludeList
		// AND this Event is not an item on its willConsume list
		// WHEN the event on the excludeList is dispatched on the EventBus
		// THEN the EventConsumer does not consume this Event
        let stubEventConsumer = ExcludeNotWillConsumeStubEventConsumer()
        let eventBus = EventBus()
        let stubEvent = StubEvent()

        eventBus.register(stubEventConsumer)
        eventBus.dispatch(stubEvent)

        XCTAssertFalse(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was unexpectedly called.")

	}

    // Event not on excludeList or willConsume is not consumed
	func testNoExcludeListWithWillConsumeEvent() {

        // GIVEN a registered EventConsumer which includes a specific Event on its excludeList
        // AND this Event is not an item on its willConsume list
        // WHEN the event on the willConsume is dispatched on the EventBus
        // THEN the EventConsumer does consume this Event
        let stubEventConsumer = ExcludeNotWillConsumeStubEventConsumer()
        let eventBus = EventBus()
        let anotherStubEvent = AnotherStubEvent()

        eventBus.register(stubEventConsumer)
        eventBus.dispatch(anotherStubEvent)

        XCTAssertTrue(check(anotherStubEvent, consumedBy: stubEventConsumer) , "EventConsumer.consume was not called or not called with the correct Event : \(anotherStubEvent.self)")
	}

    // AllEvent on exclude list overrides events on willConsume
    func testExcludeAllWithWillConsumeEvent() {

        // GIVEN a registered EventConsumer which includes an AllEvent on its excludeList
        // AND also has an Event is on its willConsume list
        // WHEN the event on the willConsume is dispatched on the EventBus
        // THEN the EventConsumer does not consume this Event
        let stubEventConsumer = ExcludeAllStubEventConsumer()
        let eventBus = EventBus()
        let stubEvent = StubEvent()

        eventBus.register(stubEventConsumer)
        eventBus.dispatch(stubEvent)

        XCTAssertFalse(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was unexpectedly called.")
    }

    // AllEvent on exclude list does not intefere with events not on willConsume, they are still not consumed
    func testExcludeAllWithNotWillConsumeEvent() {

        // GIVEN a registered EventConsumer which includes an AllEvent on its excludeList
        // AND also has an Event is on its willConsume list
        // WHEN the event not on the willConsume is dispatched on the EventBus
        // THEN the EventConsumer does not onsume this Event
        let stubEventConsumer = ExcludeAllStubEventConsumer()
        let eventBus = EventBus()
        let anotherStubEvent = AnotherStubEvent()

        eventBus.register(stubEventConsumer)
        eventBus.dispatch(anotherStubEvent)

        XCTAssertFalse(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was unexpectedly called.")
    }

	// NoEvent on excludeList results in all events being consumed, regardless of other items on the excludeList
	func testExcludeNoEventWillConsumeOtherExcludedEvents() {

		// GIVEN a registered EventConsumer which includes a NoEvent on its excludeList
		// AND also has another Event is on its excludeList list
		// WHEN the second event on the excludeList is dispatched on the EventBus
		// THEN the EventConsumer does consume this Event
		let stubEventConsumer = ExcludeNoneStubEventConsumer()
		let eventBus = EventBus()
		let stubEvent = StubEvent()

		eventBus.register(stubEventConsumer)
		eventBus.dispatch(stubEvent)

		XCTAssertTrue(check(stubEvent, consumedBy: stubEventConsumer) , "EventConsumer.consume was not called or not called with the correct Event : \(stubEvent.self)")
	}

	// NoEvent on excludeList does not intefere with the events on the willConsume list, they are stil consumed
	func testExcludeNoEventWillStillConsumeEvents() {

		// GIVEN a registered EventConsumer which includes a NoEvent on its excludeList
		// AND also has another Event is on its willConsume list
		// WHEN the event also on the willConsume is dispatched on the EventBus
		// THEN the EventConsumer does consume this Event
		let stubEventConsumer = ExcludeNoneStubEventConsumer()
		let eventBus = EventBus()
		let anotherStubEvent = AnotherStubEvent()

		eventBus.register(stubEventConsumer)
		eventBus.dispatch(anotherStubEvent)

		XCTAssertTrue(check(anotherStubEvent, consumedBy: stubEventConsumer) , "EventConsumer.consume was not called or not called with the correct Event : \(anotherStubEvent.self)")
	}
}

func check<T>(_ event: T, consumedBy consumer: TestableEventConsumer) -> Bool {

    guard consumer.consumeWasCalled else { return false }
    guard let eventConsumeCalledWith = consumer.consumeCalledWith else { return false }
    return eventConsumeCalledWith.isEqual(event)
}

class StubWillConsumeAllEventEventConsumer: TestableEventConsumer {

    override var willConsume: [Event.Type] {
        return [AllEvent.self]
    }
}

class StubWillConsumeNoEventEventConsumer: TestableEventConsumer {

    override var willConsume: [Event.Type] {
        return [StubEvent.self, AnotherStubEvent.self, NoEvent.self]
    }
}

class StubWillConsumeNoAndAllEventEventConsumer: TestableEventConsumer {

    override var willConsume: [Event.Type] {
        return [AllEvent.self, NoEvent.self]
    }
}

class ExcludeWillConsumeStubEventConsumer: TestableEventConsumer {

    override var willConsume: [Event.Type] {
        return [StubEvent.self]
    }

    override var excludeList: [Event.Type] {
        return [StubEvent.self]
    }
}

class ExcludeNotWillConsumeStubEventConsumer: TestableEventConsumer {

	override var willConsume: [Event.Type] {
		return [AnotherStubEvent.self]
	}

	override var excludeList: [Event.Type] {
		return [StubEvent.self]
	}
}

class ExcludeAllStubEventConsumer: TestableEventConsumer {

    override var willConsume: [Event.Type] {
        return [StubEvent.self]
    }

    override var excludeList: [Event.Type] {
        return [AllEvent.self]
    }
}

class ExcludeNoneStubEventConsumer: TestableEventConsumer {

	override var willConsume: [Event.Type] {
		return [AnotherStubEvent.self]
	}

	override var excludeList: [Event.Type] {
		return [NoEvent.self, StubEvent.self]
	}
}
