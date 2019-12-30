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

    let eventBus: EventBus

    init(eventBus: EventBus) {
        self.eventBus = eventBus
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
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
        case screenThree

        var targetViewControllerType: UIViewController.Type {
            switch self {
            case .screenOne:
                return ScreenOne.self
            case .screenTwo:
                return ScreenTwo.self
            case .screenThree:
                return ScreenThree.self
            }
        }
    }

    private func navigateTo(_ destination: Destination) {

        guard let targetViewController = existingUIViewController(ofType: destination.targetViewControllerType) else {
            pushViewController(createViewControler(for: destination), animated: true)
            return
        }

        popToViewController(targetViewController, animated: true)
    }

    private func existingUIViewController(ofType type: UIViewController.Type) -> UIViewController? {
        return viewControllers.filter{ $0.isKind(of: type) }.first
    }

    private func createViewControler(for destination: Destination) -> UIViewController {
        switch destination {
        case .screenOne:
            return ScreenOne(eventBus: eventBus)
        case .screenTwo:
            return ScreenTwo(eventBus: eventBus)
        case .screenThree:
            return ScreenThree(eventBus: eventBus)
        }
    }

    override var debugDescription: String {
        return "FlowController()"
    }
}
