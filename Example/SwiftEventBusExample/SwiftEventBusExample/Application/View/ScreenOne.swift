//
//  ScreenOne.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 28/12/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import UIKit
import SwiftEventBus

class ScreenOne: UIViewController {

    let eventBus: EventBus
    let button: UIButton

    // MARK: - Lifecycle
    init(eventBus: EventBus) {
        self.eventBus = eventBus
        self.button = UIButton(type: .custom)
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
        let payload = PageViewEvent.Payload(name: "Screen One", time: Date(timeIntervalSinceNow: 0))
        let event = PageViewEvent(with: payload)
        eventBus.dispatch(event)
    }
    
    // MARK: - UI
    private func createUI() {

        view.backgroundColor = .red

        button.setTitle("Go to Screen Two", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

        view.addSubview(button)
    }

    private func setupLayoutConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }

    // MARK: - Button
    @objc func handleButtonTap(sender: UIControl) {
        let event = NavigationEvent(destination: .screenTwo)
        eventBus.dispatch(event)
    }
}
