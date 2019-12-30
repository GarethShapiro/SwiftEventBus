//
//  Logger.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

class Logger: NSObject, EventConsumer {

    // MARK: - EventConsumer
    var willConsume: [Event.Type] {
        return [DidConsumeEvent.self]
    }

    func consume(_ event: Event) {
        if let didConsumeEvent = event as? DidConsumeEvent {
            print("[Logger] \(String(reflecting: didConsumeEvent.sourceConsumer)) consumed \(String(reflecting: didConsumeEvent.sourceEvent))")
        }
    }
}
