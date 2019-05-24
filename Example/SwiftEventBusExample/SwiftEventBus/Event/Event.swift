//
//  Event.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.

import Foundation

public protocol Event {
    var name: String { get }
}

// EventConsumers can elect to recieve all events by including
// this event as an item of the willConsume array.
public struct AllEvent: Event {
    public let name = "AllEvent"
}

// Used as default value on EventConsumer's excludeList list
// which avoids this property being an Optional.
public struct NoEvent: Event {
    public let name = "NoEvent"
}

// Automatically dispatched by EventBus notifying that an
// event was consumed by a consumer.
public struct DidConsumeEvent: Event {

    public let name = "DidConsumeEvent"
    
	public let sourceConsumer: EventConsumer
	public let sourceEvent: Event

    public init(sourceConsumer: EventConsumer, sourceEvent: Event) {

        self.sourceConsumer = sourceConsumer
        self.sourceEvent = sourceEvent
    }

    public static func == (lhs: DidConsumeEvent, rhs: DidConsumeEvent) -> Bool {
        return lhs.sourceConsumer.isEqual(rhs.sourceConsumer) && lhs.sourceEvent.name == rhs.sourceEvent.name
    }
}
