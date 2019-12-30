//
//  ScreenTwo.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import UIKit
import SwiftEventBus

class ScreenTwo: UIViewController {

    let eventBus: EventBus
    let screenOneButton: UIButton
    let screenThreeButton: UIButton

    // MARK: - Lifecycle
    init(eventBus: EventBus) {
        self.eventBus = eventBus
        self.screenOneButton = UIButton(type: .custom)
        self.screenThreeButton = UIButton(type: .custom)
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
        let payload = PageViewEvent.Payload(name: "Screen Two", time: Date(timeIntervalSinceNow: 0))
        let event = PageViewEvent(with: payload)
        eventBus.dispatch(event)
    }

    // MARK: - UI
    private func createUI() {

        view.backgroundColor = .orange

        screenOneButton.setTitle("Go to Screen One", for: .normal)
        screenOneButton.sizeToFit()
        screenOneButton.addTarget(self, action: #selector(handleScreenOneButtonTap), for: .touchUpInside)

        view.addSubview(screenOneButton)

        screenThreeButton.setTitle("Go to Screen Three", for: .normal)
        screenThreeButton.sizeToFit()
        screenThreeButton.addTarget(self, action: #selector(handleScreenThreeButtonTap), for: .touchUpInside)

        view.addSubview(screenThreeButton)
    }

    private func setupLayoutConstraints() {

        screenOneButton.translatesAutoresizingMaskIntoConstraints = false
        screenOneButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        screenOneButton.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true

        screenThreeButton.translatesAutoresizingMaskIntoConstraints = false

        screenThreeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        screenThreeButton.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
    }

    // MARK: - Events
    @objc func handleScreenOneButtonTap(sender: UIControl) {
        let event = NavigationEvent(destination: .screenOne)
        eventBus.dispatch(event)
    }

    @objc func handleScreenThreeButtonTap(sender: UIControl) {
        let event = NavigationEvent(destination: .screenThree)
        eventBus.dispatch(event)
    }
}
