//
//  ViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 04..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import FBSDKLoginKit

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
        
        self.view.addSubview(loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        setupNavigationItem()
    }
    
    private func setupNavigationItem()
    {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func presentMainViewController()
    {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "mainViewController")
        {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension LoginViewController : FBSDKLoginButtonDelegate
{
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if error != nil
        {
            print("error")
        }
        else if result.isCancelled
        {
            print("cancelled")
        }
        else
        {
            self.presentMainViewController()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        self.navigationItem.title = "Logged out!"
    }
}

