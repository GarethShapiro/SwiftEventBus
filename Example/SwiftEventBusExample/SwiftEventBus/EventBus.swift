//
//  EventBus.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//
import Foundation

public class EventBus {

    public init() {}
    
    private lazy var consumerList = [EventConsumer]()
    
    /**
    *
    * EventConsumers apply to consume events.
    *
    **/
    public func register(_ consumer: EventConsumer) {

        if consumerList.contains(where: { listItem in listItem.isEqual(consumer) }) == false {
            consumerList.append(consumer)
        }
    }

    /**
    *
    * Allow EventConsumers to stop consuming events.
    *
    **/
    public func deregister(_ consumer: EventConsumer) {

        consumerList = consumerList.filter({ listItem in listItem.isEqual(consumer) == false })
    }
    
    /**
    *
    * Provides the application with the abiilty to dispatch events to consumers.
    *
    ***/
    public func dispatch<T:Event>(_ event: T) {
        
        // COMMENTED
        //let eventTypeToHandle = event.type
        
        for consumer in consumerList {

            if consumer.willConsume.contains(where: { eventType in eventType is T.Type }) {
                consumer.consume(event)
            }

            /*
             if should(consumer: consumer ,  handleEventType:eventTypeToHandle){
            
                consumer.consume(event: suppliedApplicationEvent)
                
                // Immediately recursivly call with .DidConsume unless this has already happened once.
                if(eventTypeToHandle != .DidConsume){
                    
                    let didConsumEvent = ApplicationEvent(type: .DidConsume,
                                                          triggerType: eventTypeToHandle,
                                                          source: consumer)
                    
                    handle(applicationEvent:didConsumEvent)
                }
            }
             */
        }
    }
    
    
    /**
    *
    * EventConsumers consume events if :
    *
    * The event is not in the consumer's exclude list, if there is one.
    * The event is a registered event type with the consumer.
    * The consumer is handling .All events.
    *
    **/
    /*
    func should(_ consumer : EventConsumer , handle eventType : ApplicationEventType) -> Bool{
        
        var eventExcluded = false
        
        if let excludeEventTypes = consumer.excludeList{
            
            eventExcluded = excludeEventTypes.contains(suppliedEventType)
            
            if eventExcluded{
                
                return false
            }
            
        }
        
        let registeredEventTypes = consumer.registeredEventTypeList
        
        if registeredEventTypes.contains(suppliedEventType) || registeredEventTypes.contains(.All){
            
            return true
        }
        
        return false
    }
 */
    
}
