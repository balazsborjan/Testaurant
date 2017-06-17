//
//  MainPageTableViewCell.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 28..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avarageRatingLabel: UILabel!
    @IBOutlet weak var mainPictureImageView: UIImageView!
    
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 5.0
        
        mainPictureImageView.clipsToBounds = true
        mainPictureImageView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
