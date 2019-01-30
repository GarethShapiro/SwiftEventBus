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

    func doSomething() {

        // do something
        // ..

        // and afterwards dispatch an event
        dispatchFirstEvent()
    }

    private func dispatchFirstEvent() {

        let payload = FirstEvent.Payload(item: false, list: [1,2,3])
        let event = FirstEvent(payload: payload)
        
        eventBus?.dispatch(event)
    }
}
