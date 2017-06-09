//
//  Rating.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 31..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class Rating {
    
    var ID: Int!
    
    var Text: String!
    
    var RestaurantID: Int!
    
    var UserID: Int64!
    
    var Value: Float
    
    var userName: String?
    
    init?(json: [String: AnyObject]) {
        
        guard let id = json["ID"] as? Int,
            let text = json["Text"] as? String,
            let restaurantID = json["RestaurantID"] as? Int,
            let userID = json["UserID"] as? Int64,
            let value = json["Value"] as? Float
            
            else {
                
                return nil
        }
        
        self.ID = id
        self.Text = text
        self.RestaurantID = restaurantID
        self.UserID = userID
        self.Value = value
        
        getUserNameByUserID()
    }
    
    static func getRatingsByRestaurantID(matching query: String, completion: @escaping ([Rating]?) -> Void) {
        
        if let urlPath = GlobalMembers.ratingCRUD_URLs[RatingCRUD.SelectByRestaurantID] {
            
            if let url = URL(string: GlobalMembers.mainURL + urlPath + query) {
                
                let session = URLSession.shared
                
                session.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    var ratings: [Rating] = []
                    
                    if error != nil {
                        
                        print("etterem error")
                        
                        DispatchQueue.main.async {
                            
                            completion(nil)
                        }
                        
                    } else {
                        
                        print("fetching rating")
                        
                        let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [AnyObject]
                        
                        if json != nil {
                            
                            for case let result in json! {
                                
                                if let convertedResult = result as? [String: AnyObject] {
                                    
                                    if let newRating = Rating(json: convertedResult) {
                                        
                                        ratings.append(newRating)
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            
                            completion(ratings)
                        }
                    }
                    
                }).resume()
            }
        }
    }
    
    private func getUserNameByUserID() -> Void {
        
        
        let id = FBSDKAccessToken.current().userID
        
        let graphRequest = FBSDKGraphRequest(graphPath: "/\(String(describing: id))/friendlists", parameters: ["fields" : "id, name"], httpMethod: "GET")
        let connection = FBSDKGraphRequestConnection()
        
        connection.setDelegateQueue(OperationQueue.main)
        
        connection.add(graphRequest) { (connection, result, error) in
            
            if error != nil {
                
                print("user lekérés közben hiba")
                
            } else {
                
                let data = result as! [String : AnyObject]
                
                self.userName = data["name"] as? String
            }
        }
        
        connection.start()
    }
}

















