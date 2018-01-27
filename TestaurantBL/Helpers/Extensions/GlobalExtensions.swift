//
//  GlobalExtensions.swift
//  TestaurantBL
//
//  Created by Balázs Bojrán on 2018. 01. 27..
//  Copyright © 2018. Balázs Bojrán. All rights reserved.
//

import Foundation
import UIKit

public struct VisualEffectViewCreater
{
    public static func CreateVisualEffectView(for frame: CGRect, with style: UIBlurEffectStyle) -> UIVisualEffectView
    {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        visualEffectView.frame = frame
        
        return visualEffectView
    }
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int)
    {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func appDefault() -> UIColor
    {
        return UIColor(red: 251, green: 251, blue: 251)
    }
}

extension Date
{
    public static func date(from: String) -> Date
    {
        let dateFormatter = DateFormatter()
        return dateFormatter.date(from: from)!
    }
    
    public func year() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    public func toFullFormatString(withYear: Bool, withLongFormatMonth: Bool) -> String
    {
        let dateFormatter = DateFormatter()
        
        if withYear || self.year() != Date().year()
        {
            dateFormatter.dateFormat = withLongFormatMonth ? "yyyy. MMM. dd. HH:mm" : "yyyy. MM. dd. HH:mm"
        }
        else
        {
            dateFormatter.dateFormat = withLongFormatMonth ? "MMM. dd. HH:mm" : "MM. dd. HH:mm"
        }
        
        return dateFormatter.string(from: self)
    }
    
    public func toFullFormatString() -> String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        
        return dateFormatter.string(from: self)
    }
    
    public static func fromFullFormat(string date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        
        return dateFormatter.date(from: date)!
    }
    
    public func toString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        
        return dateFormatter.string(from: self)
    }
}

extension Array where Element == Float
{    /// Returns the sum of all elements in the array
    public var total: Element
    {
        return reduce(0, +)
    }
    /// Returns the average of all elements in the array
    public var average: Double
    {
        return isEmpty ? 0 : Double(reduce(0, +)) / Double(count)
    }
}
