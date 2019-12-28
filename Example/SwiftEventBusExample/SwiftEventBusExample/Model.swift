//
//  Model.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

struct Model {

    let eventBus: EventBus?

    func initialiseApplication() {
        let event = NavigationEvent(destination: .screenOne)
        eventBus?.dispatch(event)
    }
}
