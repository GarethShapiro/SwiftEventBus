//
//  AnalyticsMediator.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

final class AnalyticsMediator: NSObject, EventConsumer {

    // MARK: - EventConsumer
    var willConsume: [Event.Type] {
        return [PageViewEvent.self]
    }

    func consume(_ event: Event) {
        guard let pageViewEvent = event as? PageViewEvent else { return }
        print("[AnalyticsMediator] Send PageView anaytics: [\(pageViewEvent.payload.time.timeIntervalSince1970)] : \(pageViewEvent.payload.name)")
    }

    override var debugDescription: String {
        return "AnalyticsMediator()"
    }
}
