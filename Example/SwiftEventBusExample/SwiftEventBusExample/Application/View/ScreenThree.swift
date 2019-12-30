//
//  ScreenThree.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 28/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import UIKit
import SwiftEventBus

class ScreenThree: UIViewController {

    let eventBus: EventBus
    let message: UILabel
    let okButton: UIButton

    // MARK: - Lifecycle
    init(eventBus: EventBus) {
        self.eventBus = eventBus
        self.message = UILabel()
        self.okButton = UIButton(type: .custom)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        setupLayoutConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let payload = UserRewardPageViewEvent.Payload(name: "Screen Three", time: Date(timeIntervalSinceNow: 0))
        let event = UserRewardPageViewEvent(with: payload)
        eventBus.dispatch(event)
    }

    // MARK: - UI
    private func createUI() {

        view.backgroundColor = .brown

        message.text = "Congratulations, you have made it to sceen 3"
        view.addSubview(message)

        okButton.setTitle("OK", for: .normal)
        okButton.sizeToFit()
        okButton.addTarget(self, action: #selector(handleOkButtonTap), for: .touchUpInside)

        view.addSubview(okButton)
    }

    private func setupLayoutConstraints() {

        message.translatesAutoresizingMaskIntoConstraints = false
        message.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true

        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }

    // MARK: - Events
    @objc func handleOkButtonTap(sender: UIControl) {
        let event = NavigationEvent(destination: .screenTwo)
        eventBus.dispatch(event)
    }
}
