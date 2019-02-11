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
// which avoids this property being an Optional.
public struct NoEvent: Event {}

// Automatically dispatched by EventBus notifying that an
// event was consumed by a consumer.
public struct DidConsumeEvent<T:EventConsumer>: Event {

	public let sourceConsumer: T
	public let sourceEvent: Event

    public init(sourceConsumer: T, sourceEvent: Event) {

        self.sourceConsumer = sourceConsumer
        self.sourceEvent = sourceEvent
    }
//
//    public static func == (lhs: T, rhs: T) -> Bool {
//        return lhs.sourceConsumer == rhs.sourceConsumer && lhs.sourceEvent == rhs.sourceEvent
//    }
}
