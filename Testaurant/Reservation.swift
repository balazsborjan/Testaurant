//
//  Reservation.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 31..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import Foundation

class Reservation {
    
    var restaurant: Restaurant!
    
    var selectedPeopleCount: Int! = 1
    
    var date: Date! = Date()
    
    private let user = User.instance
    
    init(restaurant: Restaurant) {
        
        self.restaurant = restaurant
    }
    
    func sendReservation() {
        
        // MARK: Send reservation to DB -> switch response!!! -> if ok:
        
        self.user.reservations.append(self)
    }
}
