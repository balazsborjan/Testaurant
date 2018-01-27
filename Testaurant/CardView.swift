//
//  CardView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 19..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class CardView: UIView {

    var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = false
        self.layer.cornerRadius = 10.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            let rect = CGRect(x: bounds.minX - 1, y: bounds.minY - 1, width: bounds.width + 2, height: bounds.height + 2)
            
            shadowLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 10).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }        
    }
}
