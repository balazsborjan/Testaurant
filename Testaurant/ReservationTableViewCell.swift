//
//  ReservationTableViewCell.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 11..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var selectedPeopleCountLabel: UILabel!
    @IBOutlet weak var reservationDateLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    
    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        restaurantImageView.clipsToBounds = true
        restaurantImageView.layer.cornerRadius = 6.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
