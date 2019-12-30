//
//  PageViewEvent.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//
import Foundation
import SwiftEventBus

class PageViewEvent: NSObject, Event {

    let payload: Payload

    init(with payload: Payload) {        
        self.payload = payload
    }
    
    struct Payload {
        let name: String
        let time: Date
    }

    // MARK: - NSObjectProtocol
    override var debugDescription: String {
        return "PageViewEvent(payload: \(self.payload))"
    }
}

final class UserRewardPageViewEvent: PageViewEvent {}
