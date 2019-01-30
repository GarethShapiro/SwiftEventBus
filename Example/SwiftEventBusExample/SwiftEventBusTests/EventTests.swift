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

    func testAllEvent() {


    }

    class StubAllEventConsumer: NSObject, EventConsumer {

        var consumeWasCalled = false
        var consumeCalledWith: Event?

        var willConsume: [Event.Type] {
            return [AllEvent.self]
        }

        func consume<T>(_ event: T) where T: Event {
            consumeWasCalled = true
            consumeCalledWith = event
        }
    }
}


