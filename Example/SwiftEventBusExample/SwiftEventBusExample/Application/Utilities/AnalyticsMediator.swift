//
//  AnalyticsMediator.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

class AnalyticsMediator: NSObject, EventConsumer {

    // MARK: - EventConsumer
    var willConsume: [Event.Type] {
        return [PageViewEvent.self]
    }

    func consume(_ event: Event) {
        if let pageViewEvent = event as? PageViewEvent {
            print("[AnalyticsMediator] Send PageView anaytics: [\(pageViewEvent.payload.time.timeIntervalSince1970)] : \(pageViewEvent.payload.name)")
        }
    }

    override var debugDescription: String {
        return "AnalyticsMediator()"
    }
}
