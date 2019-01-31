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

	func testExcludeListWithWillConsumeEvent() {

		// GIVEN a registered EventConsumer which includes a specific Event on its excludeList
		// AND this Event is an item on its willConsumer list
		// WHEN this Event is dispatched on the EventBus
		// THEN the EventConsumer does not consume this Event
		let stubEventConsumer = ExcludeWillConsumeStubEventConsumer()
		let eventBus = EventBus()
		let stubEvent = StubEvent()

		eventBus.register(stubEventConsumer)
		eventBus.dispatch(stubEvent)

		XCTAssertFalse(stubEventConsumer.consumeWasCalled, "EventConsumer.consume was unexpectedly called.")

		if let eventConsumeCalledWith = stubEventConsumer.consumeCalledWith {
			XCTFail("EventConsumer.consume unexpectedly called with an Event : \(eventConsumeCalledWith.self)")
			return
		}
	}

	func testExcludeListWithNoWillConsumeEvent() {

		// GIVEN a registered EventConsumer which includes a specific Event on its excludeList
		// AND this Event is not an item on its willConsumer list
		// WHEN this Event is dispatched on the EventBus
		// THEN the EventConsumer does not consume this Event

	}

	func testExcludeListWithWillConsumeAllEvent() {

		// GIVEN a registered EventConsumer which includes a specific Event on its excludeList
		// AND this EventConsumer includes AllEvent on its willConsumer list
		// WHEN this Event is dispatched on the EventBus
		// THEN the EventConsumer does not consume this Event

	}
}

class ExcludeWillConsumeStubEventConsumer: NSObject, EventConsumer {

	var consumeWasCalled = false
	var consumeCalledWith: Event?

	var willConsume: [Event.Type] {
		return [StubEvent.self]
	}

	var excludeList: [Event.Type] {
		return [StubEvent.self]
	}

	func consume<T>(_ event: T) where T: Event {
		consumeWasCalled = true
		consumeCalledWith = event
	}
}
