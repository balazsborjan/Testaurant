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
    
    func getReservations(matching query: String?, completion: @escaping ([Restaurant]?) -> Void) {
        
        
    }
}
