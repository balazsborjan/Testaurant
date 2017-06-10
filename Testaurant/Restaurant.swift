//
//  Restaurant.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 23..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Restaurant: NSObject, MKAnnotation {
    
    // MARK: MapKit
    
    var coordinate = CLLocationCoordinate2D()
    
    var title: String? { return Name }
    
    var subtitle: String? { return Address }
    
    // MARK: Default implementaiton
    
    var ID: Int?
    
    var Address: String?
    
    var Name: String?
    
    var MaxPeopleAtTable: Int?
    
    var OpeningTime: String?
    
    var MainImageURL: String?
    
    var image: UIImage?
    
    var images = Array<UIImage>() {
        didSet{
            self.galeryImageDelegate?.newImageAdded()
        }
    }
    
    var galeryImagesCount: Int?
    
    var galeryImageDelegate : GaleryImageProtocol?
    
    var ratingCount: Int?  // Kell egy tábla majd, amiben az értékelések lesznek, ennek lesz egy foreignkey oszlopa a restaurantID-vel, ebből kell majd Count()-al kivenni ezt, mégpedig akkor, amikor kiválasztjuk a listából az adott éttermet.
    
    init(id: Int, address: String, name: String, maxPeaopleAtTable: Int, openingTime: String, mainImageURL: String) {
        super.init()
        
        self.ID = id
        self.Address = address
        self.Name = name
        self.MaxPeopleAtTable = maxPeaopleAtTable
        self.OpeningTime = openingTime
        self.MainImageURL = mainImageURL
    }
    
    init?(json: [String: AnyObject]) {
        super.init()
     
        guard let id = json["ID"] as? Int,
            let name = json["Name"] as? String,
            let address = json["Address"] as? String,
            let maxPeopleAtTable = json["MaxPeopleAtTable"] as? Int,
            let mainImageURL = json["MainImageURL"] as? String
            //let openingTime = json["OpeningTime"] as? String
            
        else {
            
            return nil
        }
        
        self.ID = id
        self.Address = address
        self.Name = name
        self.MaxPeopleAtTable = maxPeopleAtTable
        self.OpeningTime = nil
        self.MainImageURL = mainImageURL
        
        getGeoCoord()
        
        getGaleryImageCount()
    }
    
    private func getGeoCoord() {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(self.Address!, completionHandler: { (placemarks, error) in
            
            if let placemark = placemarks?.first {
                
                if let location = placemark.location {
                    
                    self.coordinate = location.coordinate
                }
            }
        })
    }
    
    static func getRestaurants(matching query: String?, completion: @escaping ([Restaurant]?) -> Void) {
        
        if let urlPath = GlobalMembers.restaurantCRUD_URLs[RestaurantCRUD.Select] {
            
            if let url = URL(string: GlobalMembers.mainURL + urlPath) {
            
                let session = URLSession.shared
                
                session.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    var restaurants: [Restaurant] = []
                    
                    if error != nil {
                        
                        print("etterem error")
                        
                        DispatchQueue.main.async {
                            
                            completion(nil)
                        }
                        
                    } else {
                        
                        print("fetching restaurants")
                        
                        let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [AnyObject]
                        
                        if json != nil {
                            
                            for case let result in json! {
                                
                                if let convertedResult = result as? [String: AnyObject] {
                                    
                                    if let newRestaurant = Restaurant(json: convertedResult) {
                                        
                                        restaurants.append(newRestaurant)
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            
                            completion(restaurants)
                        }
                    }
                    
                }).resume()
            }
        }
    }
    
    func getGaleryImageCount() {
        
        if let urlPath = GlobalMembers.restaurantCRUD_URLs[.GetImageCountForRestaurant] {
            
            let urlParameters = String(format: urlPath, self.ID!)
            
            let url = URL(string: GlobalMembers.mainURL + urlParameters)
            
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    
                    print("galery image count lekérés közben hiba")
                    
                } else {
                    
                    let returnData = String(describing: response)
                    
                    if returnData.lengthOfBytes(using: .utf8) > 0 {
                        
                        self.galeryImagesCount = Int(returnData)
                    }
                }
                
            }).resume()
        }
    }
}







