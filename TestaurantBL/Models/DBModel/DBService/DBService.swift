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
    private let serviceURL: String = "http://wcf.testaurant.dropthecheeseofficial.com:1993/Services/DBService.svc/"
    private let mainImageByRestaurantIdFuncName: String = "GetImageByID/%d"
    
    // MARK: DB FUNCTIONS
    public func GetRestaurants(completion: @escaping (_: Array<RestaurantDto>) -> Void) // sessionDelegate: URLSessionDelegate, 
    {
        let serviceFuncName = "GetAllRestaurant"
        var restaurants = Array<RestaurantDto>()
        
        if let url = URL(string: serviceURL + serviceFuncName)
        {
//            let sessionConfiguration = URLSessionConfiguration.default
//            let operationQueue = OperationQueue.main
            let session = URLSession.shared // configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: operationQueue
            
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
                        
                        DispatchQueue.main.async {
                            self.Restaurants = restaurants
                            completion(restaurants)
                        }                        
                    }
                }
            }).resume()
        }
    }
    
    public func GetMainImageUrl(for restaurant: RestaurantDto) -> URL?
    {
        let urlParameters = String(format: mainImageByRestaurantIdFuncName, restaurant.ID)
        let urlPath = serviceURL + urlParameters
        
        if restaurant.ID != nil
        {
            return URL(string: String(format: urlPath, restaurant.ID!))
        }
        
        return nil
    }
    
    public func GetReservations(completion: @escaping (Array<ReservationDto>) -> Void)
    {
        let getReservationsFuncName = "GetReservationsByUserID/%@"
        
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
                        
                        DispatchQueue.main.async {
                            completion(reservations)
                        }
                    }
                }
            }).resume()
        }
    }
    
    public func Send(reservation: ReservationDto, completion: @escaping (Bool) -> Void)
    {
        
        
        let sendReservationFuncName = "InsertReservation"
        
        var result = false
        
        if let url = URL(string: serviceURL + sendReservationFuncName)
        {            
            if let json = try? JSONSerialization.data(withJSONObject: reservation.toJSON(), options: .prettyPrinted)
            {
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
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
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                    
                    print(response as Any)
                    
                }).resume()
            }
        }
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







