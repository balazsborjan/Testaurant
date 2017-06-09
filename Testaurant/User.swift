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
    
    init(userID: String, name: String, firstName: String, lastName: String, email: String, profileImage: UIImage) {
        
        self.userID = userID
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profileImage = profileImage
    }
    
    init() { }
}
