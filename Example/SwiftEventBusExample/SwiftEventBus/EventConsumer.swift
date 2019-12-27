//
//  EventConsumer.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//
import Foundation

/**
Any class conforming to `NSObjectProtocol` can be registered with `EventBus` and consume `Event`s
if it adopts the `EventConsumer` protocol.
*/
public protocol EventConsumer: NSObjectProtocol {

    /**
    Contains a list of `Event`s an `EventConsumer` expects to consume.
    This is a useful place to look when debugging.
    */
    var willConsume: [Event.Type] { get }

    /**
     A point at which an `Event` is passed to an `EventConsumer` to consume.
     This method should not fail when passed an `Event` not the `EventConsumer`'s `willConsume` list.

     - Parameter event: The `Event` to consume.
     */
    func consume(_ event: Event) -> Void

    /**
     Returns a list of `Events` an `EventConsumer` explicity _does not_ consume.
	 These `Event`s will be ignored even if they are items on the `willConsume` list.
     */
     var excludeList: [Event.Type] { get }
}

public extension EventConsumer {
    /**
     `excludeList` is an empty array by default, so implementations of `EventConsumer` aren't required to declare one.
    */
    var excludeList: [Event.Type] {
         return []
    }
}
