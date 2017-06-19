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
    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainPictureImageView.clipsToBounds = true
        mainPictureImageView.layer.cornerRadius = 6.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
