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
        visualEffectView.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height + UIApplication.shared.statusBarFrame.height)
        
        return visualEffectView
    }
}

extension UIImageView
{
    public func roundCornersForAspectFit(radius: CGFloat)
    {
        if let image = self.image
        {
            //calculate drawingRect
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height
            
            var drawingRect : CGRect = self.bounds
            
            if boundsScale > imageScale
            {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            }
            else
            {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

extension UILabel
{
    public func setLabelAttributes(text: String, image: UIImage)
    {
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = image
        //Set bound to reposition
        imageAttachment.bounds = CGRect(x: 0, y: -(self.frame.maxY / 8), width: self.frame.height / 2, height: self.frame.height / 2)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add your text to mutable string
        let  textAfterIcon = NSAttributedString(string: "  \(text)")
        completeText.append(textAfterIcon)
        completeText.insert(attachmentString, at: 0)
        self.attributedText = completeText;
    }
}

extension UIResponder
{
    func next<T: UIResponder>(_ type: T.Type) -> T?
    {
        return next as? T ?? next?.next(type)
    }
}

extension UITableViewCell
{
    public var tableView: UITableView?
    {
        return next(UITableView.self)
    }
    
    public var indexPath: IndexPath?
    {
        return tableView?.indexPath(for: self)
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
