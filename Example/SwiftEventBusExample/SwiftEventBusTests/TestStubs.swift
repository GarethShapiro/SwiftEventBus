//
//  TestStubs.swift
//  SwiftEventBusTests
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

class StubEventConsumer: NSObject, EventConsumer {

    var consumeWasCalled = false
    var consumeCalledWith: Event?

    var willConsume: [Event.Type] {
        return [StubEvent.self, StubEventWithPayload.self]
    }

    func consume<T>(_ event: T) where T: Event {
        consumeWasCalled = true
        consumeCalledWith = event
    }
}

struct StubEvent: Event {}
struct NotAssociatedStubEvent: Event {}

struct StubEventWithPayload: Event {

    var payload: Payload?

    struct Payload {

        var item: Bool
        var list: [String]
    }
}
