//
//  Logger.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

final class Logger: NSObject, EventConsumer {

    // MARK: - EventConsumer
    var willConsume: [Event.Type] {
        return [DidConsumeEvent.self]
    }

    func consume(_ event: Event) {
        guard let didConsumeEvent = event as? DidConsumeEvent else { return }
        print("[Logger] \(String(reflecting: didConsumeEvent.sourceConsumer)) consumed \(String(reflecting: didConsumeEvent.sourceEvent))")
    }
}
