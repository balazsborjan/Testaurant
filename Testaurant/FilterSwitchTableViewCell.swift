//
//  FilterTableViewCell.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 20..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class FilterSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    
    @IBOutlet weak var optionSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}