//
//  RatingDto.swift
//  TestaurantBL
//
//  Created by Balázs Bojrán on 2018. 01. 27..
//  Copyright © 2018. Balázs Bojrán. All rights reserved.
//

import Foundation
import FBSDKLoginKit

public class RatingDto
{
    public var ID: Int!
    public var Text: String!
    public var RestaurantID: Int!
    public var UserID: Int64!
    public var Value: Float
    public var UserName: String?
    
    init?(json: [String: AnyObject])
    {
        guard let id = json["ID"] as? Int,
            let text = json["Text"] as? String,
            let restaurantID = json["RestaurantID"] as? Int,
            let userID = json["UserID"] as? Int64,
            let value = json["Value"] as? Float
        else
        {
            return nil
        }
        
        self.ID = id
        self.Text = text
        self.RestaurantID = restaurantID
        self.UserID = userID
        self.Value = value
        
        getUserNameByUserID()
    }
    
    private func getUserNameByUserID() -> Void
    {
        if UserService.Instance.userID == nil
        {
            return
        }
        
        let graphRequest = FBSDKGraphRequest(graphPath: UserService.Instance.userID!, parameters: ["fields" : "id, name"], httpMethod: "GET")
        let connection = FBSDKGraphRequestConnection()
        
        connection.setDelegateQueue(OperationQueue.main)
        
        connection.add(graphRequest) { (connection, result, error) in
            
            if error != nil
            {
                print("user lekérés közben hiba")
            }
            else
            {
                let data = result as! [String : AnyObject]
                self.UserName = data["name"] as? String
            }
        }
        
        connection.start()
    }
}
