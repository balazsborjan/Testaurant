//
//  ViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 04..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TestaurantBL
import NVActivityIndicatorView

let fbManager = FBSDKLoginManager()

class LoginViewController: UIViewController
{
    let loginButton = FBSDKLoginButton()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        loginButton.delegate = self
        
        loginButton.isHidden = false
        
        self.view.addSubview(loginButton)
    }
    
    func presentMainViewController()
    {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "startViewController")
        {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension LoginViewController : FBSDKLoginButtonDelegate
{
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        loginButton.isHidden = true
        NVActivityIndicatorPresenter.sharedInstance.setMessage("Bejelentkezés")
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        if error != nil
        {
            print("error")
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        else if result.isCancelled
        {
            print("cancelled")
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        else
        {
            UserService.Instance.setFBUserInfo {
                self.presentMainViewController()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        self.navigationItem.title = "Logged out!"
    }
}

