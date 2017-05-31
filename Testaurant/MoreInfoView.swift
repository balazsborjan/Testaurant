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
        
        setFBUserInfo()
        
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        
        let screenBounds = UIScreen.main.bounds
        let width = UIScreen.main.bounds.width / 5 * 4
        
        self.frame = CGRect(origin: screenBounds.origin, size: CGSize(width: width, height: screenBounds.height)) // - statusBar.height))
        //self.frame.origin.y = statusBar.maxY
        
        self.frame.origin.x = 0 - self.frame.width
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeOnSwipe(_:)))
        swipeGestureRecognizer?.direction = .left
        
        self.addGestureRecognizer(swipeGestureRecognizer!)
    }
    
    // MARK: Show/Hide view
    
    func show() {
        
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
    
    func setFBUserInfo() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, first_name, last_name, email"])
        let connection = FBSDKGraphRequestConnection()
        
        connection.setDelegateQueue(OperationQueue.main)
        
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            
            if error != nil {
                
                //ERRORHANDLING!!
                print("infolekérés közben hiba")
                
            } else {
                
                let data = result as! [String : AnyObject]
                
                self.nameLabel.text = data["name"] as? String
                
                let FBid = data["id"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.profilePicture = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            }
        })
        connection.start()
    }
}
