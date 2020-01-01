//
//  Model.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import SwiftEventBus

final class Model: NSObject, EventConsumer {

    // MARK: - Lifecycle
    let eventBus: EventBus
    private var userHasClaimedPrize = false

    init(eventBus: EventBus) {
        self.eventBus = eventBus
        super.init()
    }

    func initialiseApplication() {
        let event = NavigationEvent(destination: .screenOne)
        eventBus.dispatch(event)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - EventConsumer
    var willConsume: [Event.Type] {
        return [UserRewardPageViewEvent.self, UserClaimRewardEvent.self]
    }

    func consume(_ event: Event) {
        switch(event) {
        case is UserRewardPageViewEvent:

            if userHasClaimedPrize == false {
                let event = UserQualifiedForRewardEvent()
                eventBus.dispatch(event)
            }

        case is UserClaimRewardEvent:
            
            userHasClaimedPrize = true
            let event = RewardClaimedStateEvent()
            eventBus.dispatch(event)

        default:break
        }
    }

    // MARK: - NSObjectProtocol
    override var debugDescription: String {
        return "Model()"
    }
}
