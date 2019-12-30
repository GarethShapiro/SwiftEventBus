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
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        setupLayoutConstraints()
    }

    // MARK: - UI
    private func createUI() {

        view.backgroundColor = .brown

        message.text = "Congratulations, you have made it to sceen 3"
        view.addSubview(message)

        okButton.setTitle("OK", for: .normal)
        okButton.sizeToFit()
        okButton.addTarget(self, action: #selector(handleOkButtonPress), for: .touchUpInside)

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
    @objc func handleOkButtonPress(sender: UIControl) {
        let event = NavigationEvent(destination: .screenTwo)
        eventBus.dispatch(event)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateViewConstraints()
    }
}
