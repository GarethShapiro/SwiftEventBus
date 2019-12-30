//
//  NavigationEvent.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 28/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

class NavigationEvent: NSObject, Event {

    var destination: FlowController.Destination

    init(destination: FlowController.Destination) {
        self.destination = destination
    }

    // MARK: - NSObjectProtocol
    override var debugDescription: String {
        return "NavigationEvent(destination: \(destination))"
    }
}
