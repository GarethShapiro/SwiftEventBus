//
//  AllEvent.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation

// EventConsumers can elect to recieve all events by returning this event with the willConsume array.
public struct AllEvent: Event {}
