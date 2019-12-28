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

     `EventConsumer`s will consume an `Event` if any of the following are true

     - The `EventConsumer`'s `excludeList` contains `NoEvent`.
     - The `EventConsumer`'s `willConsume` list does not contain `NoEvent`.
     - The `EventConsumer`'s `willConsume` contains `AllEvent`.

     or all of the folowing are true


     - The `EventConsumer`'s `excludeList` does not contain `AllEvent`.
     - The `EventConsumer`'s `excludeList` does not contain the target event type.
     - The `EventConsumer`'s `willConsume` does contain the target event type.
     */
    public func dispatch(_ targetEvent: Event) {

        for consumer in consumerList {

            if matchConsumerAndEvent(consumer,targetEvent) {

                let group = DispatchGroup()

                   if targetEvent is DidConsumeEvent == false {
                       let didConsumerEvent = DidConsumeEvent(sourceConsumer: consumer, sourceEvent: targetEvent)
                       group.notify(queue: .main) { [weak self] in self?.dispatch(didConsumerEvent) }
                   }

                  group.enter()
                  consumer.consume(targetEvent)
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

        if consumer.excludeList.contains(where: { consumerEvent in consumerEvent is NoEvent.Type }) == true { return true }
        if consumer.willConsume.contains(where: { consumerEvent in consumerEvent is NoEvent.Type }) == true { return false }
        if consumer.willConsume.contains(where: { consumerEvent in consumerEvent is AllEvent.Type }) == true { return true }

        if consumer.excludeList.contains(where: { consumerEvent in consumerEvent is AllEvent.Type }) == true { return false }
        if consumer.excludeList.contains(where: { consumerEvent in targetEvent.isKind(of:consumerEvent) }) == true { return false }
        if consumer.willConsume.contains(where: { consumerEvent in targetEvent.isKind(of:consumerEvent) }) == false { return false }

        return true
    }
}
