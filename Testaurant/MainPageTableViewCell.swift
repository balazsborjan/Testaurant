//
//  MainPageTableViewCell.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 28..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import PreviewTransition
import TestaurantBL

class MainPageTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var avarageRatingLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var mainPictureImageView: UIImageView! = UIImageView()
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var freeSpaceLabel: UILabel!
//    @IBOutlet weak var visualEffectBackgroundView: UIVisualEffectView!
    
    let shadowLayer = CAShapeLayer()
    
    var shadowColor: UIColor? {
        didSet {
            if shadowColor != nil
            {
                self.shadowLayer.shadowColor = shadowColor!.cgColor
                self.contentView.layer.layoutSublayers()
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        mainPictureImageView.contentMode = .scaleAspectFill
        mainPictureImageView.clipsToBounds = true
        mainPictureImageView.layer.cornerRadius = 8
        
//        visualEffectBackgroundView.effect = UIBlurEffect(style: .light)
//        visualEffectBackgroundView.clipsToBounds = true
//        visualEffectBackgroundView.layer.cornerRadius = 12.0
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(8, 15, 8, 15))
        
        let rect = CGRect(x: contentView.frame.minX + 6, y: contentView.frame.minY + 6, width: contentView.frame.width - 12, height: contentView.frame.height - 12)
        
        shadowLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 0).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.01, height: 0.01)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 7
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}
