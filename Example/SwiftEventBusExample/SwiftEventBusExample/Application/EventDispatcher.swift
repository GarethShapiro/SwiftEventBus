//
//  EventDispatcher.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 29/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

protocol EventDispatcher {
    init(eventBus: EventBus)
}
