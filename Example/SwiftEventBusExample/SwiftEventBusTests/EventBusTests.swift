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
        // AND an Event the EventConsumer will consume (not on excludeList and on willConsume) is dispatched on the EventBus
        // THEN the consume method of the EventConsumer will be called with an instance as an argument
        let stubEventBus = EventBus()
        let stubEventConsumer = StubEventConsumer()
        let stubEvent = StubEvent()

        stubEventBus.register(stubEventConsumer)
        stubEventBus.dispatch(stubEvent)

        guard let targetEvent = stubEventConsumer.consumeCalledWith else {
            XCTFail("EventConsumer.consume was not called")
            return
        }

        XCTAssertTrue(targetEvent.isEqual(stubEvent), "EventConsumer.consume was not called with the correct Event : \(stubEvent.self)")
    }

    func testConsumeMethodWithIncorrectEvent() {

        // GIVEN an instance of EventBus
        // WHEN an EventConsumer is registered
        // AND an Event the EventConsumer will not consume (not on willConsume) is dispatched on the EventBus
        // THEN the consume method of the EventConsumer will not be called
        let stubEventBus = EventBus()
        let stubEventConsumer = StubEventConsumer()
        let anotherstubEvent = AnotherStubEvent()

        stubEventBus.register(stubEventConsumer)
        stubEventBus.dispatch(anotherstubEvent)

        XCTAssertNil(stubEventConsumer.consumeCalledWith, "EventConsumer.consume was unexpectedly called with an event.")
    }

    func testUnregisteredConsumerDoesNotConsumeEvents() {

        // GIVEN an instance of EventBus
        // WHEN an EventConsumer is registered
        // AND then subsequentlty deregistered
        // AND an Event the EventConsumer will consume is dispatched on the EventBus
        // THEN the consume method of the EventConsumer will not be called
        let stubEventBus = EventBus()
        let stubEventConsumer = StubEventConsumer()
        let stubEvent = StubEvent()

        stubEventBus.register(stubEventConsumer)
        stubEventBus.deregister(stubEventConsumer)

        stubEventBus.dispatch(stubEvent)

        XCTAssertNil(stubEventConsumer.consumeCalledWith, "EventConsumer.consume was unexpectedly called with an event.")
    }

    func testDidConsumeIsDispatchedAfterEventConsumedForOneConsumer() {

        // GIVEN an instance of EventBus
        // WHEN two EventConsumers are registered with it, the first willConsume StubEvents and the second willConsume DidConsumeEvents
        // AND the StubEvent is dispatched on the EventBus
        // THEN the consume method of the first EventConsumer is called with an instance of StubEvent as an arguement
        // AND subsequently the consume method of the second EventConsumer is called with an instance of DidConsumeEvent as an argurment
        // AND the DidConsumeEvent has references to the StubEvent and other EventConsumer
        let stubEventBus = EventBus()
        let stubEventConsumer = StubEventConsumer()
        let didConsumeStubEventConsumer = DidConsumeStubEventConsumer()

        let stubEvent = StubEvent()
        let stubDidConsumeEvent = DidConsumeEvent(sourceConsumer: stubEventConsumer, sourceEvent: stubEvent)

        let didConsumeExpectation = XCTestExpectation(description: "DidConsumeEvent not consumed")

        let didConsumeEventBlock = {

            didConsumeExpectation.fulfill()

            guard let didConsumeEvent = didConsumeStubEventConsumer.consumeCalledWith as? DidConsumeEvent else {
                XCTFail("EventConsumer.consume was not called with the correct Event : \(stubDidConsumeEvent.self)")
                return
            }

            XCTAssertTrue(didConsumeEvent.sourceEvent.isEqual(stubEvent), "Unexpected DidConsumeEvent.sourceEvent : \(didConsumeEvent.sourceEvent.self)")
        }

        didConsumeStubEventConsumer.wasConsumedBlock = didConsumeEventBlock

        stubEventBus.register(stubEventConsumer)
        stubEventBus.register(didConsumeStubEventConsumer)

        stubEventBus.dispatch(stubEvent)

        XCTAssertTrue(stubEventConsumer.consumeCalledWith is StubEvent, "EventConsumer.consume was not called with the correct Event : \(stubEvent.self)")

        wait(for: [didConsumeExpectation], timeout: 0.5)
    }
}
