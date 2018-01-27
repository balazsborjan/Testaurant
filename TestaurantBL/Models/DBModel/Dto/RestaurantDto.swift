//
//  RestaurantDto.swift
//  TestaurantBL
//
//  Created by Balázs Bojrán on 2018. 01. 27..
//  Copyright © 2018. Balázs Bojrán. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public class RestaurantDto : NSObject, MKAnnotation
{
    // MARK: MapKit
    public var coordinate = CLLocationCoordinate2D()
    public var title: String? { return Name }
    public var subtitle: String? { return Address }
    
    // MARK: Default implementation
    public var ID: Int!
    public var Address: String!
    public var Name: String!
    public var MaxPeopleAtTable: Int!
    public var MaxPeopleCount: Int!
    public var OpeningTime: String!
    public var MainImage: UIImage!
    
    // MARK: Extension properties
    public var RatingAvg: Double = 0.0
    public var GalleryImages = Array<GalleryImageDto>()
    public var Ratings = Array<RatingDto>()
    {
        didSet
        {
            CalculateAvgRating()
        }
    }    
    
    init(id: Int, address: String, name: String, maxPeaopleAtTable: Int, openingTime: String, mainImage: Data)
    {
        super.init()
        
        self.ID = id
        self.Address = address
        self.Name = name
        self.MaxPeopleAtTable = maxPeaopleAtTable
        self.OpeningTime = openingTime
        self.MainImage = UIImage(data: mainImage)
    }
    
    init?(json: [String: AnyObject])
    {
        super.init()
        
        guard let id = json["ID"] as? Int,
            let name = json["Name"] as? String,
            let address = json["Address"] as? String,
            let maxPeopleAtTable = json["MaxPeopleAtTable"] as? Int,
            let maxPeopleCount = json["MaxPeopleCount"] as? Int,
            let mainImage = UIImage(data: json["MainImageURL"] as! Data)
        else
        {
                return nil
        }
        
        self.ID = id
        self.Address = address
        self.Name = name
        self.MaxPeopleAtTable = maxPeopleAtTable
        self.MaxPeopleCount = maxPeopleCount
        self.OpeningTime = nil
        self.MainImage = mainImage
        
        getGeoCoord()
    }
    
    private func getGeoCoord()
    {        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(self.Address!, completionHandler: { (placemarks, error) in
            
            if let placemark = placemarks?.first
            {
                if let location = placemark.location
                {
                    self.coordinate = location.coordinate
                }
            }
        })
    }
    
    private func CalculateAvgRating()
    {
        var values = [Float]()
        
        for r in self.Ratings
        {
            values.append(r.Value)
        }
        
        self.RatingAvg = values.average
    }
}











