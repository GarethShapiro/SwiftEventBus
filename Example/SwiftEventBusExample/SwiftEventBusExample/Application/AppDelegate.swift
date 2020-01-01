//
//  AppDelegate.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import UIKit
import SwiftEventBus

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let eventBus: EventBus

    lazy var model: Model = Model(eventBus: eventBus)
    let flowController: FlowController

    // MARK: - Lifecycle
    override init() {
        self.eventBus = EventBus()
        self.flowController = FlowController(eventBus: eventBus)

        super.init()

        registerEventConsumers()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = flowController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()

        model.initialiseApplication()

        return true
    }

    // MARK: - EventBus
    private func registerEventConsumers() {
        let eventConsumers: [EventConsumer] = [model, flowController, Logger(), AnalyticsMediator()]
        for consumer in eventConsumers { eventBus.register(consumer) }
    }
}
