//
//  FirstEvent.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

struct FirstEvent: Event {

    let name = "FirstEvent"

    var payload: Payload?

    struct Payload {

        var item: Bool
        var list: [Int]
    }
}
