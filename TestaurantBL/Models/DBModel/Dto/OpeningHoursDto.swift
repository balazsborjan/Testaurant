//
//  OpeningHoursDto.swift
//  TestaurantBL
//
//  Created by Balázs Bojrán on 2018. 01. 27..
//  Copyright © 2018. Balázs Bojrán. All rights reserved.
//

import Foundation

public class OpeningHoursDto : NSObject
{
    var ID: Int!
    var restaurantID: Int!
    
    var Monday: String!
    var Tuesday: String!
    var Wednesday: String!
    var Thursday: String!
    var Friday: String!
    var Saturday: String!
    var Sunday: String!
    
    override init()
    {
        super.init()
    }
    
    init?(json: [String: AnyObject])
    {
        super.init()
        
        guard let rID = json["RestaurantID"] as? Int?,
            let id = json["ID"] as? Int?,
            let m = json["Monday"] as? String,
            let tu = json["Tuesday"] as? String,
            let w = json["Wednesday"] as? String,
            let th = json["Thursday"] as? String,
            let f = json["Friday"] as? String,
            let sa = json["Saturday"] as? String,
            let su = json["Sunday"] as? String
            
            else {
                return nil
        }
        
        self.ID = id
        self.restaurantID = rID
        self.Monday = m
        self.Tuesday = tu
        self.Wednesday = w
        self.Thursday = th
        self.Friday = f
        self.Saturday = sa
        self.Sunday = su
    }
}
