//
//  EventConsumer.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//
import Foundation

// EventConsumers need to be compared so NSObjectProtocol for the easy win
public protocol EventConsumer: NSObjectProtocol {

    /**
     *
     *  Containst a list of Event Types an EventConsumer implmentation expects to consume.
     *  This is a useful place to look when debugging
     *
     **/
    var willConsume : [Event.Type] { get }

    /**
     *
     *   A point at which an Event is passed to an EventConsumer to consume.
     *   This method should not fail when passed Event not the EventConsumer's registeredEventTypeList
     *
     **/
    func consume<T:Event>(_ event: T) -> Void


    /**
     *
     *  Returns a list of ApplicationEventTypes an EventConsumer implmentation explicity does not consume.
x     *
     *
     **/
    //var excludeList : [ApplicationEventType]  { get }
}

/**
 *
 * Supply a default value for excludeList, effectivly making it optional.
 *

extension EventConsumer{

    var excludeList : [ApplicationEventType]?{
        get { return .none }
    }
}
**/
