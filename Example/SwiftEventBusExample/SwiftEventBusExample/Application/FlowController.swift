//
//  FlowController.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 28/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import UIKit
import SwiftEventBus

class FlowController: UINavigationController, EventConsumer {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }

    // MARK: - EventConsumer
    var willConsume: [Event.Type] {
        return [ NavigationEvent.self ]
    }

    func consume(_ event: Event) {
        switch event {
        case let navigationEvent as NavigationEvent:
            navigateTo(navigationEvent.destination)
        default: break;
        }
    }

    // MARK: - Navigation
    enum Destination {
        case screenOne
        case screenTwo

        var targetViewControllerType: UIViewController.Type {
            switch self {
            case .screenOne:
                return ScreenOne.self
            case .screenTwo:
                return ScreenTwo.self
            }
        }
    }

    private func navigateTo(_ destination: Destination) {

        guard let targetViewController = existingUIViewController(ofType: destination.targetViewControllerType) else {
            pushViewController(destination.targetViewControllerType.init(), animated: true)
            return
        }

        popToViewController(targetViewController, animated: true)
    }

    private func existingUIViewController(ofType type: UIViewController.Type) -> UIViewController? {
        return viewControllers.filter{ $0.isKind(of: type) }.first
    }
}
