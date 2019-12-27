//
//  FirstEvent.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

class FirstEvent: NSObject, Event {

    var payload: Payload?

    init(payload: Payload) {        
        self.payload = payload
    }
    
    struct Payload {
        var item: Bool
        var list: [Int]
    }
}
