//
//  EventBus.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//
import Foundation

public class EventBus {

    typealias ExcludeListComposition = (no: Int,all: Int,match: Int)
    
    public init() {}
    private lazy var consumerList = [EventConsumer]()
    
    /**
    *
    * EventConsumers register to consume events.
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
    * EventConsumers will consume an Event if (in order):
    *
    * The consumer's willConsume list does not contain NoEvent
    * The consumer's exclude list is not excluding AllEvent
    * The consumer's exclude list is excluding NoEvent
    * The consumer's exclude does not include the target event type
    *
    * The event target type is in the consumer's willConsume list
    * AllEvent is on the consumer's willConsumer list
    *
    **/
    public func dispatch<T:Event>(_ event: T) {

        for consumer in consumerList {

            guard consumer.willConsume.contains(where: { event in event is NoEvent.Type }) == false else { break }

            if matchConsumerAndEvent(consumer,event) {

                // This DispatchGroup is used to allow dispatch() to return before DidConsumeEvent is dispatched.
                // This allows more accuarate tests to be written.  For eg:
                
                // ExcludeNoneStubEventConsumer does not need to exlude DidConsumeEvent, which it would need to do
                // to succesfully test whether the NoEvent on it's exclude list is working properly.
                let group = DispatchGroup()
                
                if event is DidConsumeEvent == false {
                    
                    let didConsumerEvent = DidConsumeEvent(sourceConsumer: consumer, sourceEvent: event)
                    group.notify(queue: .main) { [weak self] in self?.dispatch(didConsumerEvent) }
                }
                
                group.enter()
                consumer.consume(event)
                group.leave()
            }
        }
    }
    
    private func matchConsumerAndEvent(_ consumer: EventConsumer, _ targetEvent: Event) -> Bool {

        let excludeListComposition: ExcludeListComposition = consumer.excludeList.reduce(ExcludeListComposition(0,0,0)) { (compositionSoFar, excludeEvent) -> ExcludeListComposition in
            
            var compositionSoFar = compositionSoFar
            
            if excludeEvent is NoEvent.Type { compositionSoFar.no = compositionSoFar.no + 1 }
            if excludeEvent is AllEvent.Type { compositionSoFar.all = compositionSoFar.all + 1 }
            if targetEvent.isKind(of:excludeEvent) { compositionSoFar.match = compositionSoFar.match + 1 }
            
            return compositionSoFar
        }
        
        if excludeListComposition.all > 0 { return false }
        if excludeListComposition.no > 0 { return true }
        if excludeListComposition.match > 0 { return false }
     
        // NoEvent on willConsume is checked in dispatch() before the call to matchConsumerAndEvent() and not repeated here.
        let willConsumeListComposition: ExcludeListComposition = consumer.willConsume.reduce(ExcludeListComposition(0,0,0)) { (compositionSoFar, excludeEvent) -> ExcludeListComposition in
            
            var compositionSoFar = compositionSoFar
            
            if excludeEvent is AllEvent.Type { compositionSoFar.all = compositionSoFar.all + 1 }
            if targetEvent.isKind(of:excludeEvent) { compositionSoFar.match = compositionSoFar.match + 1 }
            
            return compositionSoFar
        }
        
        if willConsumeListComposition.match > 0 { return true }
        if willConsumeListComposition.all > 0 { return true }
        
        return false
    }
}
