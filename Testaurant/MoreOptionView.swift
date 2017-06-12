//
//  MoreOptionView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 26..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class MoreOptionView: UIView {

    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var showMapButton: UIButton!
    
    func setFrame(by searchBarFrame: CGRect) {
        
        self.frame = searchBarFrame
        
        self.clipsToBounds = true
        
        let bottomBorder = UIView(frame: CGRect(origin: CGPoint(x: 0, y: self.frame.maxY - 2), size: CGSize(width: self.frame.width, height: 2)))
        bottomBorder.backgroundColor = UIColor.appDefault()
        
        self.addSubview(bottomBorder)
    }
}
