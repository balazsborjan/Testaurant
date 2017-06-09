//
//  GaleryCollectionViewCell.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 31..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class GaleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 7.0
    }
    
    func setFrame(x: Int, width: CGFloat) {
        
        self.frame = CGRect(
            x: CGFloat(x).remainder(dividingBy: 4) * width,
            y: self.frame.origin.y,
            width: width,
            height: width
        )
        
        self.imageView.frame = self.bounds
    }
}
