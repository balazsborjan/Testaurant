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
    
    static func getImages(completion: (Bool) -> Void) {
        
        for restaurant in globalContainer.restaurants {
            
            if let data = (globalContainer.cdMainImages.filter({ Int($0.restaurantID) == restaurant.ID }).first?.image) as Data? {
                
                _ = restaurant.setImage(withData: data, fromDB: false)
                
            } else {
                
                // MARK: NEM ASYNC!!!
                if restaurant.getImageFromDBSync(completion: restaurant.setImage(withData:fromDB:)) {
                    
                    completion((false))
                    break
                }
            }
        }
        
        completion((true))
    }
    
    private func getImageFromDBAsync(completion: @escaping (Data?, Bool) -> Void) {
        
        if let url = URL(string: self.MainImageURL!) {
            
            let session = URLSession.shared
            
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    
                    print("image error")
                    completion(nil, false)
                    
                } else {
                    
                    print("fetching restaurants")
                    
                    if data != nil {
                        
                        DispatchQueue.main.async {
                            
                            completion(data!, true)
                        }
                        
                    } else {
                        
                        print("data nil")
                        completion(nil, false)
                    }
                }
                
            }).resume()
        }
    }
    
    private func getImageFromDBSync(completion: @escaping (Data?, Bool) -> Bool) -> Bool {
        
        if let url = URL(string: self.MainImageURL!) {
            
            if let data = try? Data(contentsOf: url) {
                
                _ = completion(data, true)
                
            } else {
                
                return false
            }
        }
        
        return true
    }
    
    private func setImage(withData data: Data?, fromDB: Bool) -> Bool {
        
        if data != nil {
            
            self.image = UIImage(data: data!)
            
            print("\(self.ID!) - image ok - fromDB: \(fromDB)")
            
            if fromDB {
                
                let newMainImage = MainImage(context: managedObjectContext!)
                
                newMainImage.restaurantID = Int32(self.ID!)
                newMainImage.image = data! as NSData
                
                globalContainer.cdMainImages.append(newMainImage)
            }
            
            return true
            
        } else {
            
            return false
        }
    }
    
    func getImages() {
        
        if let urlPath = GlobalMembers.restaurantCRUD_URLs[RestaurantCRUD.GetImageCountForRestaurant] {
            
            let urlParameters = String(format: urlPath, self.ID!)
            
            if let url = URL(string: GlobalMembers.mainURL + urlParameters) {
                
                do {
                    
                    _ = try Data(contentsOf: url)
                    
                    // MARK: Át kellene konvertálni (vagy JSON-be lekérni) ezt a count-ot!!!
                    
                    doGetImages(count: 5)
                    
                } catch {
                    
                    print("count lekérésnél hiba")
                }
            }
        }
    }
    
    private func doGetImages(count: Int) {
        
        if let urlPath = GlobalMembers.restaurantCRUD_URLs[RestaurantCRUD.GetImageByRestaurantIDAndRowNUM] {
            
            var newImages = Array<UIImage>()
            
            for i in 1...count {
                
                let urlParameters = String(format: urlPath, self.ID!, i)
                
                if let url = URL(string: GlobalMembers.mainURL + urlParameters) {
                    
                    let session = URLSession.shared
                    
                    session.dataTask(with: url, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            
                            print("képlekérés error")
                            
                        } else {
                            
                            if data != nil {
                                
                                if let newImage = UIImage(data: data!) {
                                    
                                    DispatchQueue.main.async {
                                        
                                        newImages.append(newImage)
                                        
                                        self.images = newImages
                                    }
                                }
                                
                            } else {
                                
                                print("képlekérés data nil")
                            }
                        }
                    }).resume()
                }
            }
        }
    }
}







