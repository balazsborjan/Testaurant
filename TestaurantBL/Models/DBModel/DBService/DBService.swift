//
//  DBService.swift
//  TestaurantBL
//
//  Created by Balázs Bojrán on 2018. 01. 27..
//  Copyright © 2018. Balázs Bojrán. All rights reserved.
//

import Foundation

// MARK: DB Műveletek végrehajtására szolgáló service
public class DBService
{
    // MARK: Singleton inicializálás
    public static let Instance = DBService()
    
    private init() { }
    
    // MARK: Extension properties
    public var Restaurants = Array<RestaurantDto>()
    
    // MARK: DB url-ek definiálása
    private let serviceURL: String = "http://wcf.testaurant.dropthecheeseofficial.com:1993/Services/TestaurantDBService.svc/"
    private let mainImageByRestaurantIdFuncName: String = "GetMainImageById/%d"
    
    // MARK: DB FUNCTIONS
    public func GetRestaurants() -> Array<RestaurantDto>
    {
        let serviceFuncName = "GetAllEtterem"
        var restaurants = Array<RestaurantDto>()
        
        if let url = URL(string: serviceURL + serviceFuncName)
        {
            let session = URLSession.shared
            
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil
                {
                    print("etterem error")
                }
                else
                {
                    print("fetching restaurants")
                    
                    let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [AnyObject]
                    
                    if json != nil
                    {
                        for case let result in json!
                        {
                            if let convertedResult = result as? [String: AnyObject]
                            {
                                if let newRestaurant = RestaurantDto(json: convertedResult)
                                {
                                    restaurants.append(newRestaurant)
                                }
                            }
                        }
                    }
                }
                
            }).resume()
        }
        
        self.Restaurants = restaurants
        return restaurants
    }
    
    public func GetMainImageUrl(for restaurant: RestaurantDto) -> URL?
    {
        let urlPath = serviceURL + mainImageByRestaurantIdFuncName
        
        if restaurant.ID != nil
        {
            return URL(fileURLWithPath:  String(format: urlPath, restaurant.ID!))
        }
        
        return nil
    }
    
    public func GetReservations() -> Array<ReservationDto>
    {
        let getReservationsFuncName = "GetReservationsByUserId/%@"
        
        let urlParameters = String(format: getReservationsFuncName, UserService.Instance.userID!)
        
        var reservations = Array<ReservationDto>()
        
        if let url = URL(string: serviceURL + urlParameters)
        {
            let session = URLSession.shared
            
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil
                {
                    //ERRORHANDLING!!!
                    print("foglalás error")
                }
                else
                {
                    let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                    
                    if json != nil
                    {
                        for case let result in json!
                        {
                            if let convertedResult = result as? [String: AnyObject]
                            {
                                if let newReservation = ReservationDto(json: convertedResult)
                                {
                                    reservations.append(newReservation)
                                }
                            }
                        }
                    }
                }
            }).resume()
        }
        
        return reservations
    }
    
    public func Send(reservation: ReservationDto) -> Bool
    {
        let sendReservationFuncName = "InsertReservation"
        
        var result = false
        
        if let url = URL(string: serviceURL + sendReservationFuncName)
        {            
            if let json = try? JSONSerialization.data(withJSONObject: reservation.toJSON(), options: .prettyPrinted)
            {
                let request = NSMutableURLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = json
                
                let session = URLSession.shared
                
                session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                    
                    if error != nil
                    {
                        //ERRORHANDLING!!!
                    }
                    else
                    {
                        if let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        {
                            reservation.ID = Int(truncating: json as! NSNumber)
                            result = true
                        }
                    }
                    
                    print(response as Any)
                    
                }).resume()
            }
        }
        
        return result
    }
    
    public func GetRatingsBy(restaurant: RestaurantDto) -> Array<RatingDto>
    {
        let getRatingsByRestaurantFuncName = "GetRatingsByRestaurantId/%d"
        
        var ratings = Array<RatingDto>()
        
        if let url = URL(string: serviceURL + String(format: getRatingsByRestaurantFuncName, restaurant.ID!))
        {
            let session = URLSession.shared
            
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil
                {
                    //ERRORHANDLING!!!
                    print("értékelés error")
                }
                else
                {
                    let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [AnyObject]
                    
                    if json != nil
                    {
                        for case let result in json!
                        {
                            if let convertedResult = result as? [String: AnyObject]
                            {
                                if let newRating = RatingDto(json: convertedResult)
                                {
                                    ratings.append(newRating)
                                }
                            }
                        }
                    }
                }
            }).resume()
        }
        
        return ratings
    }
    
    public func GetOpeningHoursBy(restaurant: RestaurantDto) -> OpeningHoursDto
    {
        let getOpeningHoursByRestaurantFuncName = "GetOpeningHoursByRestaurantId/%d"
        
        let parameters = String(format: getOpeningHoursByRestaurantFuncName, restaurant.ID!)
        
        var openingHours: OpeningHoursDto!
        
        if let url = URL(string: serviceURL + parameters)
        {
            let session = URLSession.shared
            
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil
                {
                    print("OpeningHours error")
                }
                else
                {
                    let json = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [AnyObject]
                    
                    if json != nil
                    {
                        for case let result in json!
                        {
                            if let convertedResult = result as? [String: AnyObject]
                            {
                                if let newHour = OpeningHoursDto(json: convertedResult)
                                {
                                    openingHours = newHour
                                }
                            }
                        }
                    }
                }
            }).resume()
        }
        
        return openingHours
    }
}







