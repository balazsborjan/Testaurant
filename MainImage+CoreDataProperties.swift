//
//  MainImage+CoreDataProperties.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 30..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import Foundation
import CoreData


extension MainImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainImage> {
        return NSFetchRequest<MainImage>(entityName: "MainImage")
    }

    @NSManaged public var restaurantID: Int32
    @NSManaged public var image: NSData?

}
