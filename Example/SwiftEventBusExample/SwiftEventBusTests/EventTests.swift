//
//  EventTests.swift
//  SwiftEventBusTests
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import XCTest
import Foundation
import SwiftEventBus

class EventTests: XCTestCase {

    func testEventPayloadIntact() {

        // GIVEN an Event with a payload
        // WHEN an EventConsumer consumes this event
        // THEN the payload available to the consumer should the same as the one the Event was initialised with
        let stubPayload = StubEventWithPayload.Payload(item: true, list: ["one","two"])
        let stubEvent = StubEventWithPayload(payload: stubPayload)

        let stubEventBus = EventBus()
        let stubEventConsumer = StubEventConsumer()
        stubEventBus.register(stubEventConsumer)

        stubEventBus.dispatch(stubEvent)

        guard let targetEvent = stubEventConsumer.consumeCalledWith as? StubEventWithPayload else {
            XCTFail("EventConsumer.consume was not called with the correct Event : \(stubEvent.self)")
            return
        }

        guard let targetPayload = targetEvent.payload else {
            XCTFail("Expected payload found on consumed Event")
            return
        }

        XCTAssertEqual(stubPayload.item, targetPayload.item, "Payload on consumed Event differs from the one supplied (1)")
        XCTAssertEqual(stubPayload.list, targetPayload.list, "Payload on consumed Event differs from the one supplied (2)")
    }

    func testWillConsumeAllEvent() {

		// GIVEN an EventConsumer which includes the AllEvent as an item in the willConsume array
		// AND this EventConsumer is registered with an EventBus
		// WHEN events not included in the EventConsumers willConsumer array are dispatched on the EventBus
		// THEY are consumed by the EventConsumer
		let stubEventBus = EventBus()
		let stubEventConsumer = StubWillConsumeAllEventEventConsumer()
		stubEventBus.register(stubEventConsumer)

		let stubEvent = StubEvent()
		stubEventBus.dispatch(stubEvent)
        XCTAssertTrue(check(stubEvent, consumedBy: stubEventConsumer) , "EventConsumer.consume was not called or not called with the correct Event : \(stubEvent.self)")

		let anotherStubEvent = AnotherStubEvent()
		stubEventBus.dispatch(anotherStubEvent)
		XCTAssertTrue(check(stubEvent, consumedBy: stubEventConsumer) , "EventConsumer.consume was not called or not called with the correct Event : \(anotherStubEvent.self)")
    }

    func testWillConsumeNoEvent() {

        // GIVEN an EventConsumer which includes the NoEvent as an item in its willConsume array
        // AND this EventConsumer includes other events as items in its willConsume array
        // AND is registered with an EventBus
        // WHEN any of the other events included in the EventConsumers willConsumer array are dispatched on the EventBus
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

    // NoEvent overrides AllEvent in willConsume
    func testNoEventPrecedence() {

        // GIVEN an EventConsumer which includes the NoEvent and AllEvent as items in its willConsume array
        // AND it is registered with an EventBus
        // WHEN any events dispatched on the EventBus
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

    func check<T>(_ event: T, consumedBy consumer: TestableEventConsumer) -> Bool {

        guard consumer.consumeWasCalled else { return false }
        guard let eventConsumeCalledWith = consumer.consumeCalledWith else { return false }
        return eventConsumeCalledWith is T
	}

    class TestableEventConsumer: NSObject, EventConsumer {

        var consumeWasCalled = false
        var consumeCalledWith: Event?

        var willConsume: [Event.Type] { return [] }

        func consume<T>(_ event: T) where T: Event {
            consumeWasCalled = true
            consumeCalledWith = event
        }
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
}


