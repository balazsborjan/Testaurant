//
//  OpenAppViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 27..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import MapKit

class OpenAppViewController: UIViewController
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if (FBSDKAccessToken.current() == nil)
        {
            navigateToLoginViewController()
        }
        else
        {
            navigateToMainPageViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    fileprivate func showNetworkAlert()
    {
        
    }
    
    fileprivate func navigateToLoginViewController()
    {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "loginVC")
        {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    fileprivate func navigateToMainPageViewController()
    {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "mainViewController")
        {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}






