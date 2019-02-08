//
//  Event.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.

import Foundation

public protocol Event {}

// EventConsumers can elect to recieve all events by including
// this event as an item of the willConsume array.
public struct AllEvent: Event {}

// Used as default value on EventConsumer's excludeList list
// which avoids this property being an Optional
public struct NoEvent: Event {}

// Automciatically dispatched by EventBus notifying that an
// event was consumed by a consumer
public struct DidConsumeEvent: Event {

	let consumer: EventConsumer
	let event: Event
}
