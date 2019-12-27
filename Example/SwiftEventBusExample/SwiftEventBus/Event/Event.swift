//
//  Event.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.

import Foundation

/**
Any class conforming to `NSObjectProtocol` can be dispatched by the `EventBus`
and consumed by `EventConsumer`s if it adopts the `Event` protocol.
 */
public protocol Event: NSObjectProtocol { } // NSObjectProtocol provides `Equatable` conformance.

/**
 `EventConsumer`s can elect to recieve _all_ events by including this event as an item on its `willConsume` array or
elect to recieve no events by including this event as an item on its `excludeList` array.
 */
public class AllEvent: NSObject, Event { }

/**
`EventConsumer`s can elect to recieve _no_ events by including this event as an item on its `willConsume` array.
 Used as default value on EventConsumer's excludeList list, which avoids this property being an Optional.
*/
public class NoEvent: NSObject, Event { }

/**
 Automatically dispatched by `EventBus` noting that an `Event` was consumed by an `EventConsumer`.
 This allows chains of events to be created.

 - Requires sourceConsumer: The `EventConsumer`
 - Requires sourceEvent: The `Event`
*/
public class DidConsumeEvent: NSObject, Event {

	public let sourceConsumer: EventConsumer
	public let sourceEvent: Event

    public init(sourceConsumer: EventConsumer, sourceEvent: Event) {

        self.sourceConsumer = sourceConsumer
        self.sourceEvent = sourceEvent
    }
}
