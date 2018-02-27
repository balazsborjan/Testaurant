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
    var RestaurantID: Int!
    
    public var Monday: String!
    public var Tuesday: String!
    public var Wednesday: String!
    public var Thursday: String!
    public var Friday: String!
    public var Saturday: String!
    public var Sunday: String!
    
    init(restaurantId: Int, monday: String, tuesday: String, wednesday: String, thursday: String, friday: String, saturday: String, sunday: String)
    {
        ID = 0
        RestaurantID = restaurantId
        Monday = monday
        Tuesday = tuesday
        Wednesday = wednesday
        Thursday = thursday
        Friday = friday
        Saturday = saturday
        Sunday = sunday
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
        self.RestaurantID = rID
        self.Monday = m
        self.Tuesday = tu
        self.Wednesday = w
        self.Thursday = th
        self.Friday = f
        self.Saturday = sa
        self.Sunday = su
    }
}
