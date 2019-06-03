//
//  TestStubs.swift
//  SwiftEventBusTests
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

class TestableEventConsumer: NSObject, EventConsumer {

    var consumeWasCalled = false
    var consumeCalledWith: Event?

    var willConsume: [Event.Type] { return [] }
    var excludeList: [Event.Type] { return [] }

    func consume<T>(_ event: T) where T: Event {
            consumeWasCalled = true
            consumeCalledWith = event
    }
}

class StubEventConsumer: TestableEventConsumer {

    override var willConsume: [Event.Type] {
        return [StubEvent.self, StubEventWithPayload.self]
    }
}

class DidConsumeStubEventConsumer: TestableEventConsumer {
    
    var wasConsumedBlock: (() -> Void)?
    
    override func consume<T>(_ event: T) where T: Event {
        super.consume(event)
        wasConsumedBlock?()
    }
    
    override var willConsume: [Event.Type]{
        return [DidConsumeEvent.self]
    }
}

class StubEvent: NSObject, Event {
    public let name = "StubEvent"
}

class AnotherStubEvent: NSObject, Event {
    public let name = "AnotherStubEvent"
}

class StubEventWithPayload: NSObject, Event {

    public let name = "StubEventWithPayload"
    
    var payload: Payload

    init(payload: Payload) {
        
        self.payload = payload
    }
    
    struct Payload {

        var item: Bool
        var list: [String]
    }
}
