//
//  User.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 09..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var userID: String?
    
    var name: String?
    
    var firstName: String?
    
    var lastName: String?
    
    var email: String?
    
    var profileImage: UIImage?
    
    var reservations = [Reservation]()
    
    static let instance = User()
    
    private init() { }
    
    func getReservations() {
        
        if let urlPath = GlobalMembers.reservationCRUD_URLs[ReservationCRUD.SelectByUserID] {
            
            let urlParameters = String(format: urlPath, userID!)
            
            if let url = URL(string: GlobalMembers.mainURL + urlParameters) {
                
                let session = URLSession.shared
                
                session.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        
                        print("foglalás error")
                        
                    } else {
                        
                        print("fetching reservation")
                        
                        let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                        
                        if json != nil {
                            
                            for case let result in json! {
                                
                                if let convertedResult = result as? [String: AnyObject] {
                                    
                                    if let newReservation = Reservation(json: convertedResult) {
                                        
                                        self.reservations.append(newReservation)
                                    }
                                }
                            }
                        }
                    }
                    
                }).resume()
            }
        }
    }
}
