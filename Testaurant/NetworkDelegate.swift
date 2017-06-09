//
//  NetworkDelegate.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 02..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import Foundation

public protocol NetworkDelegate : NSObjectProtocol {
    
    func restaurantRequestFinished(successed: Bool)
    
    func restaurantImageRequestFinished(seccessed: Bool)
}

public protocol RatingNetworkProtocol : NSObjectProtocol {
    
    func ratingRequestFinished(successed: Bool)
}

public protocol GaleryImageProtocol : NSObjectProtocol {
    
    func newImageAdded()
}
