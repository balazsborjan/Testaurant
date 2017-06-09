//
//  SelectedRestaurantView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 08..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class SelectedRestaurantContentView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bounds = CGRect(origin: self.bounds.origin, size: CGSize(width: UIScreen.main.bounds.width, height: self.bounds.height))
    }
}
