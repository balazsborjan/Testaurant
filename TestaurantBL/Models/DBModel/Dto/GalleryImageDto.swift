//
//  GalleryImageDto.swift
//  TestaurantBL
//
//  Created by Balázs Bojrán on 2018. 01. 27..
//  Copyright © 2018. Balázs Bojrán. All rights reserved.
//

import Foundation

public class GalleryImageDto : NSObject
{
    public var ID: Int!
    public var Image: Data!
    public var RestaurantID: Int!
    
    public init(id: Int, image: Data, restaurantId: Int)
    {
        super.init()
        
        self.ID = id
        self.Image = image
        self.RestaurantID = restaurantId
    }
    
    init?(json: [String: AnyObject])
    {
        super.init()
        
        guard let id = json["ID"] as? Int,
            let image = json["Image"] as? Data,
            let restaurantId = json["RestaurantID"] as? Int
        else
        {
            return nil
        }
        
        self.ID = id
        self.Image = image
        self.RestaurantID = restaurantId
    }
}
