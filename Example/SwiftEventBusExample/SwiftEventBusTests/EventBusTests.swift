//
//  EventBusTests.swift
//  SwiftEventBusTests
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import XCTest
import SwiftEventBus

class EventBusTests: XCTestCase {

    func testConsumeMethodWithCorrectEvent() {

        // GIVEN an instance of EventBus
        // WHEN an EventConsumer is registered
        // AND an Event the EventConsumer will consume is dispatched on the EventBus
        // THEN the consume method of the EventConsumer will be called with an instance as an argument
        let stubEventBus = EventBus()
        let stubEventConsumer = StubEventConsumer()
        let stubEvent = StubEvent()

        stubEventBus.register(stubEventConsumer)
        stubEventBus.dispatch(stubEvent)

        XCTAssertTrue(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was not called.")

        guard let eventConsumeCalledWith = stubEventConsumer.consumeCalledWith else {
            XCTFail("Something is very wrong.  EventConsumer.consume was not called with an Event")
            return
        }

        XCTAssertTrue(eventConsumeCalledWith is StubEvent, "EventConsumer.consume was not called with the correct Event : \(stubEvent.self)")
    }

    func testConsumeMethodWithIncorrectEvent() {

        // GIVEN an instance of EventBus
        // WHEN an EventConsumer is registered
        // AND an Event the EventConsumer will not consume is dispatched on the EventBus
        // THEN the consume method of the EventConsumer will not be called
        let stubEventBus = EventBus()
        let stubEventConsumer = StubEventConsumer()
        let stubEvent = AnotherStubEvent()

        stubEventBus.register(stubEventConsumer)
        stubEventBus.dispatch(stubEvent)

        XCTAssertFalse(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was unexpectedly called.")

        if let _ = stubEventConsumer.consumeCalledWith {
            XCTFail("Something is very wrong.  EventConsumer.consume was called with an Event")
            return
        }
    }

    func testUnregisteredConsumerDoesNotConsumeEvents() {

        // GIVEN an instance of EventBus
        // WHEN an EventConsumer is registered
        // AND then subsequentlty deregister
        // AND an Event the EventConsumer will consume is dispatched on the EventBus
        // THEN the consume method of the EventConsumer will not be called
        let stubEventBus = EventBus()
        let stubEventConsumer = StubEventConsumer()
        let stubEvent = StubEvent()

        stubEventBus.register(stubEventConsumer)
        stubEventBus.deregister(stubEventConsumer)

        stubEventBus.dispatch(stubEvent)

        XCTAssertFalse(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was unexpectedly called.")

        if let _ = stubEventConsumer.consumeCalledWith {
            XCTFail("Something is very wrong.  EventConsumer.consume was called with an Event")
            return
        }
    }
}
