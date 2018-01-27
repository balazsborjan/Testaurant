//
//  ReservationDto.swift
//  TestaurantBL
//
//  Created by Balázs Bojrán on 2018. 01. 27..
//  Copyright © 2018. Balázs Bojrán. All rights reserved.
//

import Foundation

public class ReservationDto
{
    public var ID: Int?
    public var UserID: String! = UserService.Instance.userID!
    public var RestaurantID: Int!
    public var SelectedPeopleCount: Int! = 1
    public var ReservationDate = Date()
    
    public init(restaurant: RestaurantDto)
    {
        self.RestaurantID = restaurant.ID
    }
    
    init?(json: [String : AnyObject])
    {
        guard let id = json["ID"] as? Int,
            let restaurantID = json["RestaurantID"] as? Int,
            let peopleCount = json["PeopleCount"] as? Int,
            let newDate = json["Date"] as? String
        else
        {
                return nil
        }
        
        self.ID = id
        self.SelectedPeopleCount = peopleCount
        self.RestaurantID = restaurantID
        self.ReservationDate = Date.fromFullFormat(string: newDate)
    }
    
    public func toJSON() -> [String: Any?]
    {
        return [
            "ID":"0",
            "UserID":UserID,
            "RestaurantID":RestaurantID,
            "PeopleCount":SelectedPeopleCount,
            "Date":ReservationDate.toFullFormatString()
        ]
    }
}
