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

        XCTAssertEqual(stubPayload.item, targetEvent.payload.item, "Payload on consumed Event differs from the one supplied (1)")
        XCTAssertEqual(stubPayload.list, targetEvent.payload.list, "Payload on consumed Event differs from the one supplied (2)")
    }
}


