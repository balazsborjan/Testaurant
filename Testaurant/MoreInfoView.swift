//
//  MoreInfoView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 25..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MoreInfoView: UIView {

    let didChangeStateEvent = Event<Bool>()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView! {
        
        didSet {
            
            self.layer.borderColor = headerView.backgroundColor?.cgColor
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView! {
        
        didSet {
            
            if profileImageView != nil {
                
                profileImageView.clipsToBounds = true
                profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            }
        }
    }
    
    private var profilePicture: UIImage? {
        
        didSet {
            
            if profilePicture != nil {
                
                self.profileImageView.image = profilePicture
            }
        }
    }
    
    private var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        
        let screenBounds = UIScreen.main.bounds
        let width = UIScreen.main.bounds.width / 5 * 4
        
        self.frame = CGRect(origin: screenBounds.origin, size: CGSize(width: width, height: screenBounds.height))
        
        self.frame.origin.x = 0 - self.frame.width
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeOnSwipe(_:)))
        swipeGestureRecognizer?.direction = .left
        
        self.addGestureRecognizer(swipeGestureRecognizer!)
    }
    
    // MARK: Show/Hide view
    
    func show() {
        
        if self.profilePicture == nil {
            
            self.profilePicture = User.instance.profileImage
        }
        
        if self.nameLabel.text != User.instance.name {
            
            self.nameLabel.text = User.instance.name
        }
        
        self.superview?.bringSubview(toFront: self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = 0
        })
        
        didChangeStateEvent.raise(data: false)
    }
    
    func hide(completion: ((Bool) -> Void)?) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = 0 - self.frame.width
        }, completion: completion)
        
        didChangeStateEvent.raise(data: true)
    }
    
    @objc private func closeOnSwipe(_ sender: UISwipeGestureRecognizer) {
        
        self.hide(completion: nil)
    }
}
