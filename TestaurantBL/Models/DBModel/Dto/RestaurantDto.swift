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
    public var FreeSpace: Int = 0
    public var OpeningHours: OpeningHoursDto!
    public var Latitude: Double!
    public var Longitude: Double!
    
    public var MainImage: UIImageView!
    
    // MARK: Extension properties
    public var AvgRating: Double = 0.0
    public var GalleryImages = Array<GalleryImageDto>()
    public var GalleryImageCount: Int = 0
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
        self.MainImage = UIImageView(image: UIImage(data: mainImage))
    }
    
    init?(json: [String: AnyObject])
    {
        super.init()
        
        guard let id = json["ID"] as? Int,
            let name = json["Name"] as? String,
            let address = json["Address"] as? String,
            let maxPeopleAtTable = json["MaxPeopleAtTable"] as? Int,
            let maxPeopleCount = json["MaxPeopleCount"] as? Int,
            let freeSpace = json["FreeSpace"] as? Int,
            let avgRating = json["AvgRating"] as? Double,
            let galleryImageCount = json["GalleryImageCount"] as? Int,
            let latitude = json["Latitude"] as? Double,
            let longitude = json["Longitude"] as? Double,
            let monday = json["Monday"] as? String,
            let tuesday = json["Monday"] as? String,
            let wednesday = json["Monday"] as? String,
            let thursday = json["Monday"] as? String,
            let friday = json["Monday"] as? String,
            let saturday = json["Monday"] as? String,
            let sunday = json["Monday"] as? String
        else
        {
                return nil
        }
        
        self.ID = id
        self.Address = address
        self.Name = name
        self.MaxPeopleAtTable = maxPeopleAtTable
        self.MaxPeopleCount = maxPeopleCount
        self.OpeningHours = OpeningHoursDto(
            restaurantId: self.ID, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday)
        self.FreeSpace = freeSpace
        self.AvgRating = avgRating
        self.GalleryImageCount = galleryImageCount
        self.Latitude = latitude
        self.Longitude = longitude
        self.MainImage = UIImageView()
        
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
                    return
                }
            }
        })
        
        if self.coordinate.latitude == 0.0 || self.coordinate.longitude == 0.0
        {
            self.coordinate = CLLocationCoordinate2D(latitude: self.Latitude, longitude: self.Longitude)
        }
    }
    
    private func CalculateAvgRating()
    {
        var values = [Float]()
        
        for r in self.Ratings
        {
            values.append(r.Value)
        }
        
        self.AvgRating = values.average
    }
}











