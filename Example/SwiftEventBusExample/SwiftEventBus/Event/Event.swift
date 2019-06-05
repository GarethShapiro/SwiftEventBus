//
//  Event.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.

import Foundation

public protocol Event: NSObjectProtocol { }

// EventConsumers can elect to recieve all events by including
// this event as an item of the willConsume array.
public class AllEvent: NSObject, Event { }

// Used as default value on EventConsumer's excludeList list
// which avoids this property being an Optional.
public class NoEvent: NSObject, Event { }

// Automatically dispatched by EventBus notifying that an
// event was consumed by a consumer.
public class DidConsumeEvent: NSObject, Event {

	public let sourceConsumer: EventConsumer
	public let sourceEvent: Event

    public init(sourceConsumer: EventConsumer, sourceEvent: Event) {

        self.sourceConsumer = sourceConsumer
        self.sourceEvent = sourceEvent
    }
}
