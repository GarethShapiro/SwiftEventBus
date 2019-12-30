//
//  UserRewardEvents.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//
import Foundation
import SwiftEventBus

class ShowUserRewardEvent: NSObject, Event { }
class HideUserRewardEvent: NSObject, Event { }
class UserClaimRewardEvent: NSObject, Event { }
