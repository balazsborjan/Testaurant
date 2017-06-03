//
//  GlobalMembers.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 23..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
let statusBar = UIApplication.shared.statusBarFrame

let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

let globalContainer = GlobalContainer()

class GlobalContainer {
    
    var cdMainImages: [MainImage] = []
    var restaurants: [Restaurant] = []
    var filteredRestaurants: [Restaurant] = []
    
    let restaurantsLoadedEvent = Event<Void>()
    
    var networkDelegate: NetworkDelegate?
    
    init() {
        
        fetchMainImages()
        //fetchRestaurants()
    }
    
    private func fetchMainImages() {
        
        do {
            
            cdMainImages = try (managedObjectContext?.fetch(MainImage.fetchRequest()))!
            
        } catch let error {
            
            print(error.localizedDescription)
            
            cdMainImages = []
        }
    }
    
    func fetchRestaurants() {
        
        Restaurant.getRestaurants(matching: nil) { (newRestaurants) in
            
            if newRestaurants != nil {
                
                self.restaurants = newRestaurants!
                
                self.networkDelegate?.restaurantRequestFinished(successed: true)
                
                Restaurant.getImages(completion: self.allRestaurantsLoaded)
            
            } else {
                
                self.networkDelegate?.restaurantRequestFinished(successed: false)
            }
        }
    }
    
    private func allRestaurantsLoaded(successed: Bool) {
        
        if managedObjectContext != nil && managedObjectContext!.hasChanges {
            
            try? managedObjectContext!.save()
        }
        
        self.networkDelegate?.restaurantImageRequestFinished(seccessed: true)
        
        //self.restaurantsLoadedEvent.raise(data: ())
    }
}

struct GlobalMembers {
    
    static let mainURL: String = "http://wcftestazureapp.azurewebsites.net/Service1.svc/"
    
    static let restaurantCRUD_URLs: Dictionary<RestaurantCRUD, String> = [
        
        .Select : "GetAllEtterem"
    ]
}

enum RestaurantCRUD {
    
    case Select
    case Create
    case Update
    case Delete
}

enum AnimationStyle {
    
    case animation
    case noAnimation
}

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

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension Date {
    
    static func date(from: String) -> Date {
        
        let dateFormatter = DateFormatter()
        
        return dateFormatter.date(from: from)!
    }
    
    func year() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self)
    }
    
    func toFullFormatString(withYear: Bool, withLongFormatMonth: Bool) -> String {
        
        let dateFormatter = DateFormatter()
        
        if withYear || self.year() != Date().year() {
            
            dateFormatter.dateFormat = withLongFormatMonth ? "yyyy. MMM. dd. HH:mm" : "yyyy. MM. dd. HH:mm"
            
        } else {
            
            dateFormatter.dateFormat = withLongFormatMonth ? "MMM. dd. HH:mm" :  "MM. dd. HH:mm"
        }
        
        
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self)
    }
    
    func toString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self)
    }
}








