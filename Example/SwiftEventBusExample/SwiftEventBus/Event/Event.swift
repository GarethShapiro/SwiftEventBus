//
//  Event.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.

import Foundation

public enum EventType {
    case all
    case system
}

public protocol Event: NSObjectProtocol {
    var eventType: EventType { get }
}

// EventConsumers can elect to recieve all events by including
// this event as an item of the willConsume array.
public class AllEvent: NSObject, Event {
    public let eventType: EventType = .system
}

// Used as default value on EventConsumer's excludeList list
// which avoids this property being an Optional.
public class NoEvent: NSObject, Event {
    public let eventType: EventType = .system
}

// Automatically dispatched by EventBus notifying that an
// event was consumed by a consumer.
public class DidConsumeEvent: NSObject, Event {

    public let eventType: EventType = .system
    
	public let sourceConsumer: EventConsumer
	public let sourceEvent: Event

    public init(sourceConsumer: EventConsumer, sourceEvent: Event) {
        self.sourceConsumer = sourceConsumer
        self.sourceEvent = sourceEvent
    }
}
