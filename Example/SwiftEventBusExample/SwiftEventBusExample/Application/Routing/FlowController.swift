//
//  FlowController.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 28/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import UIKit
import SwiftEventBus

final class FlowController: UIViewController, EventConsumer {

    let eventBus: EventBus
    let navController: UINavigationController
    let userRewardCTA: UIButton
    var prizeUIHeightConstraint: NSLayoutConstraint?

    // MARK: - Lifecycle
    init(eventBus: EventBus) {
        self.eventBus = eventBus
        self.navController = UINavigationController()
        self.userRewardCTA = UIButton(type: .custom)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        setupLayoutConstraints()
    }

    // MARK: - UI
    private func createUI() {
        userRewardCTA.setTitle("Click here to win a prize", for: .normal)
        userRewardCTA.backgroundColor = .darkGray
        userRewardCTA.addTarget(self, action: #selector(handleUserRewardCTATap), for: .touchUpInside)

        view.addSubview(userRewardCTA)
        view.addSubview(navController.view)

        navController.isNavigationBarHidden = true
    }

    private func setupLayoutConstraints() {
        userRewardCTA.translatesAutoresizingMaskIntoConstraints = false

        prizeUIHeightConstraint = userRewardCTA.heightAnchor.constraint(equalToConstant: 0)
        prizeUIHeightConstraint?.isActive = true

        userRewardCTA.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        userRewardCTA.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        userRewardCTA.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true

        navController.view.translatesAutoresizingMaskIntoConstraints = false
        navController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navController.view.topAnchor.constraint(equalTo: userRewardCTA.bottomAnchor).isActive = true
        navController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    // MARK: - Button Events
    @objc func handleUserRewardCTATap(sender: UIControl) {
        let event = UserClaimRewardEvent()
        eventBus.dispatch(event)
    }

    // MARK: - Prize UI
    private func hidePrizeUI() {
        view.layoutIfNeeded()
        prizeUIHeightConstraint?.constant = 0

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func showPrizeUI() {
        view.layoutIfNeeded()
        prizeUIHeightConstraint?.constant = 100

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    // MARK: - EventConsumer
    var willConsume: [Event.Type] {
        return [NavigationEvent.self, UserQualifiedForRewardEvent.self, RewardClaimedStateEvent.self]
    }

    func consume(_ event: Event) {
        switch event {
        case let navigationEvent as NavigationEvent:
            navigateTo(navigationEvent.destination)
        case is UserQualifiedForRewardEvent:
            showPrizeUI()
        case is RewardClaimedStateEvent:
            hidePrizeUI()
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
            navController.pushViewController(createViewControler(for: destination), animated: true)
            return
        }

        navController.popToViewController(targetViewController, animated: true)
    }

    private func existingUIViewController(ofType type: UIViewController.Type) -> UIViewController? {
        return navController.viewControllers.filter{ $0.isKind(of: type) }.first
    }

    // MARK: - Screen Factory
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

    // MARK: - NSObjectProtocol
    override var debugDescription: String {
        return "FlowController()"
    }
}
