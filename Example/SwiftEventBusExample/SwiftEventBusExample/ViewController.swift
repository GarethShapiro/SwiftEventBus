//
//  ViewController.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import UIKit
import SwiftEventBus

class ViewController: UIViewController, EventConsumer {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view?.backgroundColor = .blue
    }

    // EventConsumer
    var willConsume : [Event.Type] {
        return [FirstEvent.self]
    }

    func consume(_ event: Event) -> Void {

        switch event {
        case is FirstEvent:

            print("consuming FirstEvent")

            guard let firstEvent = event as? FirstEvent else { return }
            guard let payload = firstEvent.payload else { return }

            print("A payload was dispatched with FirstEvent and the item in payload is \(payload.item) and the list is \(payload.list)")

        default:
            print("do not handle this type of event \(event)")
        }
    }
}

