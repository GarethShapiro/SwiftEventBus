//
//  UserRewardEvents.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//
import Foundation
import SwiftEventBus

class UserQualifiedForRewardEvent: NSObject, Event { }
class UserClaimRewardEvent: NSObject, Event { }
class RewardClaimedStateEvent: NSObject, Event { }
