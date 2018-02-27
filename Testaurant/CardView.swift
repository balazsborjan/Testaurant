//
//  CardView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 19..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class CardView: UIView
{
    var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.clipsToBounds = false
        self.layer.cornerRadius = 5.0
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            let rect = CGRect(x: bounds.minX - 5, y: bounds.minY - 5, width: bounds.width + 6, height: bounds.height + 6)
            
            shadowLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 5).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            shadowLayer.shadowColor = UIColor.lightGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
//            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
