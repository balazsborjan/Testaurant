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
        self.layer.cornerRadius = 5.0
    }
    
    func setFrame(at indexPath: IndexPath, width: CGFloat) {
        
        self.frame = CGRect(
            x: CGFloat(indexPath.row) * width,
            y: CGFloat(indexPath.section) * width,
            width: width,
            height: width
        )
        
        self.imageView.frame = self.bounds
    }
}
