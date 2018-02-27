//
//  CollapsableHeaderView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2018. 02. 17..
//  Copyright © 2018. Kacsak. All rights reserved.
//

import UIKit

class CollapsableHeaderView: UIView
{
    var isCollapsed: Bool = false
    {
        didSet
        {
            if isCollapsed
            {
                self.actionButton.setImage(#imageLiteral(resourceName: "down-arrow-icon"), for: .normal)
            }
            else
            {
                self.actionButton.setImage(#imageLiteral(resourceName: "up-arrow-icon"), for: .normal)
            }
        }
    }
    
    let titleLabel: UILabel =
    {
        let label = UILabel()
        
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    var actionButton: UIButton =
    {
        let button = UIButton()
        
        button.setImage(#imageLiteral(resourceName: "up-arrow-icon"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.tintColor = UIColor.white
        
        return button
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        titleLabel.frame = CGRect(x: 10, y: 0, width: frame.width / 2, height: frame.height)
        actionButton.frame = CGRect(x: titleLabel.frame.maxX, y: 0, width: (frame.width / 2) - 20, height: frame.height)
        
        self.addSubview(titleLabel)
        self.addSubview(actionButton)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
