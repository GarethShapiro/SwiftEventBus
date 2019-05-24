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

        XCTAssertTrue(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was not called.")
        XCTAssertTrue(stubEventConsumer.consumeCalledWith is StubEvent, "EventConsumer.consume was not called with the correct Event : \(stubEvent.self)")
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

        XCTAssertFalse(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was unexpectedly called.")
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
    }

    func testDidConsumeIsDispatchedAfterEventConsumedForOneConsumer() {

        // GIVEN an instance of EventBus
        // WHEN two EventConsumers are registered with it, the first willConsume StubEvents and the second willConsume DidConsumeEvents
        // AND the stub Event is dispatched on the EventBus
        // THEN the consume method of the first EventConsumer is called with an instance of the stub event as an arguement
        // AND subsequently the consume method of the second EventConsumer is called with an instance of DidConsumeEvent as an argurment
        // AND the DidConsumeEvent has references to the original event and original consumer
        let stubEventBus = EventBus()
        let stubEventConsumer = StubEventConsumer()
        let didConsumeStubEventConsumer = DidConsumeStubEventConsumer<StubEventConsumer>()

        let stubEvent = StubEvent()
        let stubDidConsumeEvent: DidConsumeEvent = DidConsumeEvent(sourceConsumer: stubEventConsumer, sourceEvent: stubEvent)

        let didConsumeExpectation = XCTestExpectation(description: "DidConsumeEvent not consumed")

        let didConsumeEventBlock = {

            didConsumeExpectation.fulfill()

            guard let didConsumeEvent = didConsumeStubEventConsumer.consumeCalledWith as? DidConsumeEvent else {
                XCTFail("EventConsumer.consume was not called with the correct Event : \(stubDidConsumeEvent.self)")
                return
            }

/*
            XCTAssertEqual(didConsumeEvent.sourceEvent.Type, stubEvent.Type,"Unexpected DidConsumeEvent.sourceEvent : \(didConsumeEvent.sourceEvent.self)")
*/


        }

        didConsumeStubEventConsumer.wasConsumedBlock = didConsumeEventBlock

        stubEventBus.register(stubEventConsumer)
        stubEventBus.register(didConsumeStubEventConsumer)

        stubEventBus.dispatch(stubEvent)

        XCTAssertTrue(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was not called.")
        XCTAssertTrue(stubEventConsumer.consumeCalledWith is StubEvent, "EventConsumer.consume was not called with the correct Event : \(stubEvent.self)")

        wait(for: [didConsumeExpectation], timeout: 0.5)
    }
}
