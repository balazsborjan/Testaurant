//
//  MoreOptionView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 26..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class MoreOptionView: UIView {

//    @IBOutlet weak var sortButton: UIButton!
//    @IBOutlet weak var filterButton: UIButton!
//    @IBOutlet weak var showMapButton: UIButton!
    
    func setFrame(by searchBarFrame: CGRect) {
        
        self.frame = searchBarFrame
        
        self.clipsToBounds = true
        
        let bottomBorder = UIView(frame: CGRect(origin: CGPoint(x: 0, y: self.frame.maxY - 1), size: CGSize(width: self.frame.width, height: 1)))
        bottomBorder.backgroundColor = UIColor.darkGray
        
        self.addSubview(bottomBorder)
        
//        let containerEffect = UIBlurEffect(style: .dark)
//        let containerView = UIVisualEffectView(effect: containerEffect)
//        containerView.frame = self.filterButton.frame
//        
//        containerView.isUserInteractionEnabled = false // Edit: so that subview simply passes the event through to the button
//        
//        self.filterButton.insertSubview(containerView, belowSubview: self.filterButton.imageView!)
//        
//        let vibrancy = UIVibrancyEffect(blurEffect: containerEffect)
//        let vibrancyView = UIVisualEffectView(effect: vibrancy)
//        vibrancyView.frame = containerView.bounds
//        containerView.contentView.addSubview(vibrancyView)
//        
//        vibrancyView.contentView.addSubview(self.filterButton.imageView!)
    }
}
