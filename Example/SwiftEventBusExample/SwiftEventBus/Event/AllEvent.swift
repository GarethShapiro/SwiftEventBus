//
//  AllEvent.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation

// EventConsumers can elect to recieve all events by including
// this event as an item of the willConsume array.
public struct AllEvent: Event {}
