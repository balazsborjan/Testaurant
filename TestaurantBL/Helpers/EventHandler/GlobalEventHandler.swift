//
//  TestaurantExceptionHandler.swift
//  TestaurantBL
//
//  Created by Balázs Bojrán on 2018. 01. 27..
//  Copyright © 2018. Balázs Bojrán. All rights reserved.
//

import Foundation

// MARK: Event Handling
public class Event<T> {
    
    public typealias EventHandler = (T) -> ()
    
    fileprivate var eventHandlers = [Invocable]()
    
    public func raise(data: T) {
        
        for handler in self.eventHandlers {
            
            handler.invoke(data: data)
        }
    }
    
    public func addHandler<U: AnyObject>(target: U, handler: @escaping EventHandler) -> Disposable {
        
        let wrapper = EventHandlerWrapper(target: target, handler: handler, event: self)
        
        eventHandlers.append(wrapper)
        
        return wrapper
    }
}

private class EventHandlerWrapper<T: AnyObject, U> : Invocable, Disposable {
    
    weak var target: T?
    
    let handler: (U) -> ()
    let event: Event<U>
    
    init(target: T?, handler: @escaping (U) -> (), event: Event<U>) {
        
        self.target = target
        self.handler = handler
        self.event = event;
    }
    
    func invoke(data: Any) -> () {
        
        if target != nil {
            
            handler(data as! U)
        }
    }
    
    func dispose() {
        
        event.eventHandlers = event.eventHandlers.filter { $0 !== self }
    }
}

public protocol Disposable {
    
    func dispose()
}

private protocol Invocable: class {
    
    func invoke(data: Any)
}
