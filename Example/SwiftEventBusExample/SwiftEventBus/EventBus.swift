//
//  EventBus.swift
//  SwiftEventBus
//
//  Created by Gareth Shapiro on 30/01/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//
import Foundation

 /**
 The `EventBus` class mediates a register of `EventConsumer`s and also provides
 a mechanism to dispatch `Event`s to them.
 */
public class EventBus {

    typealias ExcludeListComposition = (no: Int,all: Int,match: Int)

    public init() {}
    private lazy var consumerList = [EventConsumer]()
    
    /**
     `EventConsumer`s register with an `EventBus` in order to to consume `Event`s.
     - Parameter consumer: The `EventConsumer` being registered.
    */
    public func register(_ consumer: EventConsumer) {
        if consumerList.contains(where: { listItem in listItem.isEqual(consumer) }) == false {
            consumerList.append(consumer)
        }
    }

    /**
     Should `EventConsumer`s wish to stop consuming `Event`s they are deregistered using this method.
     - Parameter consumer: The `EventConsumer` being deregistered.
    */
    public func deregister(_ consumer: EventConsumer) {
        consumerList = consumerList.filter({ listItem in listItem.isEqual(consumer) == false })
    }

    /**
     This method provides the application with the ability to dispatch `Event`s to `EventConsumer`s.
     - Parameter event: The `Event` to be dispatched.

     `EventConsumer`s will consume an `Event` if _all_ of the following are true :

     - The `EventConsumer`'s `willConsume` list does not contain `NoEvent`.
     - The `EventConsumer`'s `excludeList` does not contain `AllEvent`.
     - The `EventConsumer`'s `excludeList` does contain `NoEvent`.
     - The `EventConsumer`'s `excludeList` does not contain the target event type.

     and _at least one_ of the following is true :

     - The `EventConsumer`'s `willConsume` does contain the target event type.
     - The `EventConsumer`'s `willConsume` does contain `AllEvent`.
     */
    public func dispatch(_ event: Event) {

        for consumer in consumerList {

            guard consumer.willConsume.contains(where: { event in event is NoEvent.Type }) == false else { break }

            if matchConsumerAndEvent(consumer,event) {

                // This DispatchGroup is used to allow dispatch() to return before DidConsumeEvent is dispatched.
                // This allows more accuarate tests to be written.  For eg:
                
                // ExcludeNoneStubEventConsumer does not need to exclude DidConsumeEvent, which it would need to do
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

    /**
    Contains the business logic used to determine whether a specific `Event` should be consumed by a specific `EventConsumer`.
     - Parameter consumer: An `EventConsumer`.
     - Parameter targetEvent: The `Event`.
    */
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
