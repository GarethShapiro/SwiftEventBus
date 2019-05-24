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
    ***/
    public func dispatch<T:Event>(_ event: T) {

        for consumer in consumerList {

            guard consumer.willConsume.contains(where: { event in event is NoEvent.Type }) == false else { break }

            if matchConsumerAndEvent(consumer,event) {

                let group = DispatchGroup()  // what's this dispatch group for?
                group.enter()
                consumer.consume(event)

                switch T.self {
                    
                case is DidConsumeEvent:
                    let didConsumerEvent = DidConsumeEvent(sourceConsumer: consumer, sourceEvent: event)
                    dispatch(didConsumerEvent)
                default:
                    () // do nothing
                }
                
                group.leave()
            }
         
            //       let didNotConsumerEvent = makeDidConsumeEvent(consumer, event)
            

        //    let didNotConsumerEvent = makeDidConsumeEvent(consumer, event)

                //makeDidConsumeEvent(consumer, event)


          //  let consumerType = DidConsumeEvent<EventConsumer>

			//if event is DidConsumeEvent<consumer.Type> == false {

//                let didNotConsumerEvent = DidConsumeEvent(sourceConsumer: consumer, sourceEvent: event)
//
//                group?.notify(queue: .main) {
//                    [weak self] in
//                    self?.dispatch(didNotConsumerEvent)
//                }
			//}

        }
    }

    /**
    *
    * EventConsumers consume Events if:
    *
	* The event type is not in the consumer's exclude list, if there is one.
	*
	* and then either
	*
	* the event type is in the consumer's willConsumer list
	*
	* or
	*
    * the consumer is handling AllEvent events.
    *
    **/
    private func matchConsumerAndEvent<T:Event>(_ consumer: EventConsumer, _ eventType: T) -> Bool {

		if consumer.excludeList.contains(where:
			{ event in event is NoEvent.Type })
			{ return true}

		if consumer.excludeList.contains( where:
            { eventType in eventType is AllEvent.Type || eventType is T.Type } )
            { return false }

		if consumer.willConsume.contains( where:
			{ eventType in eventType is AllEvent.Type || eventType is T.Type })
			{ return true }

        return false
    }
}
