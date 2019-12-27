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
    var eventBus: EventBus

    lazy var model: Model = Model(eventBus: eventBus)
    var viewController: ViewController

    override init() {

        eventBus = EventBus()
        viewController = ViewController()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        eventBus.register(viewController)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()

        model.doSomething()

        return true
    }
}
