//
//  MoreInfoView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 25..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TestaurantBL

class MoreInfoView: UIView {

//    let didChangeStateEvent = Event<Bool>()
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    
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
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
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
        
        if self.profilePicture == nil
        {
            self.profilePicture = UserService.Instance.profileImage
        }
        
        if self.nameLabel.text != UserService.Instance.name
        {
            self.nameLabel.text = UserService.Instance.name
        }
        
        self.superview?.bringSubview(toFront: self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = 0
        })
    }
    
    func hide(completion: ((Bool) -> Void)?)
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = 0 - self.frame.width
        }, completion: completion)
    }
    
    @objc private func closeOnSwipe(_ sender: UISwipeGestureRecognizer)
    {
        self.hide(completion: nil)
    }
}
