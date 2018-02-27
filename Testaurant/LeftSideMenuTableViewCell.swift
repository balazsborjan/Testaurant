//
//  LeftSideMenuTableViewCell.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2018. 02. 09..
//  Copyright © 2018. Kacsak. All rights reserved.
//

import UIKit

class LeftSideMenuTableViewCell: UITableViewCell
{
    var iconImageView = UIImageView()
    
    var titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints()
    {
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        self.iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        self.iconImageView.widthAnchor.constraint(equalTo: self.iconImageView.heightAnchor, multiplier: 1).isActive = true
        
        self.titleLabel.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 10).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
    }
}
