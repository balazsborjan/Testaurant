//
//  Reservation.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 31..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import Foundation

class Reservation {
    
    var ID: Int?
    
    var restaurant: Restaurant!
    
    var selectedPeopleCount: Int! = 1
    
    var date: Date! = Date()
    
    private let user = User.instance
    
    init(restaurant: Restaurant) {
        
        self.restaurant = restaurant
    }
    
    init?(json: [String : AnyObject]) {
        
        guard let id = json["ID"] as? Int,
            let restaurantID = json["RestaurantID"] as? Int,
            let peopleCount = json["PeopleCount"] as? Int,
            let newDate = json["Date"] as? String
            
            else {
                
                return nil
        }
        
        self.ID = id
        self.selectedPeopleCount = peopleCount
        self.restaurant = globalContainer.restaurants.filter{ $0.ID == restaurantID }.first
        self.date = Date.fromFullFormat(string: newDate)
    }
    
    func sendReservation(completion: (() -> Void)?) {
        
        // MARK: Send reservation to DB -> switch response!!! -> if ok:
        
        if let urlPath = GlobalMembers.reservationCRUD_URLs[ReservationCRUD.Create] {
            
            let parameters = String(format: urlPath, arguments: [
                String(describing: self.user.userID!),
                String(describing: self.restaurant.ID!),
                self.date.toFullFormatString(),
                String(describing: self.selectedPeopleCount!)]
            )
            
            if let url = URL(string: GlobalMembers.mainURL +  parameters) {
                
                let session = URLSession.shared
                
                session.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        
                        print("foglalás error")
                        
                    } else {
                        
                        if let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) {
                            
                            self.ID = Int(json as! NSNumber)
                            
                            self.reservationSent()
                            
                            DispatchQueue.main.async {
                                
                                completion?()
                            }
                        }
                    }
                    
                }).resume()
            }
        }
    }
    
    private func reservationSent() {
        
        self.user.reservations.append(self)
    }
}
