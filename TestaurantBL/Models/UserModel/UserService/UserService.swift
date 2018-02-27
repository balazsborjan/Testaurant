//
//  selfService.swift
//  TestaurantBL
//
//  Created by Balázs Bojrán on 2018. 01. 27..
//  Copyright © 2018. Balázs Bojrán. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

// MARK: Alkalmazásba bejelentkezett self kezeléséle szolgáló service
public class UserService
{
    // MARK: Singleton példányosítás
    public static let Instance = UserService()
    
    private init() { }
    
    // MARK: Global properties
    public var userID: String?
    public var name: String?
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var profileImage: UIImage?
    
    // MARK: FUNCTIONS
    public func setFBUserInfo(completion: @escaping () -> Void)
    {        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name, last_name, email"])
        let connection = FBSDKGraphRequestConnection()
        
        connection.setDelegateQueue(OperationQueue.main)
        
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            
            if error != nil
            {
                //ERRORHANDLING!!
            }
            else
            {
                let data = result as! [String : AnyObject]
                
                self.userID = data["id"] as? String
                self.name = data["name"] as? String
                self.email = data["email"] as? String
                self.firstName = data["first_name"] as? String
                self.lastName = data["last_name"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(self.userID!)/picture?type=large&return_ssl_resources=1")
                self.profileImage = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        })
        connection.start()
    }
    
    public func logout(completion: () -> Void)
    {
        self.email = nil
        self.firstName = nil
        self.lastName = nil
        self.profileImage = nil
        self.userID = nil
        self.name = nil
        completion()
    }
}
