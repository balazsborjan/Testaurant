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
import TestaurantBL
import JTMaterialTransition
import NVActivityIndicatorView

let activityData = ActivityData(
    size: CGSize(width: 60, height: 60),
    message: "Bejelentkezés",
    messageFont: UIFont.boldSystemFont(ofSize: 23),
    type: NVActivityIndicatorType.ballScaleMultiple,
    color: UIColor.white,
    padding: nil,
    displayTimeThreshold: 0,
    minimumDisplayTime: 1000,
    backgroundColor: UIColor.black.withAlphaComponent(0.9),
    textColor: UIColor.white)

class OpenAppViewController: UIViewController
{
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var helperButton: UIButton!
    var transition: JTMaterialTransition?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helperButton.backgroundColor = UIColor.init(red: 104, green: 104, blue: 104, alpha: 0)
        self.transition = JTMaterialTransition(animatedView: helperButton)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        enableBasicLocationServices()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    fileprivate func showNetworkAlert()
    {
        
    }
    
    fileprivate func enableBasicLocationServices()
    {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus()
        {
            case .notDetermined:
                // Request when-in-use authorization initially
                locationManager.requestWhenInUseAuthorization()
                break
            default:
                break
        }
    }
    
    fileprivate func navigateToNextPage()
    {
        if (FBSDKAccessToken.current() == nil)
        {
            navigateToLoginViewController()
        }
        else
        {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Bejelentkezés")
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            
            UserService.Instance.setFBUserInfo {
                self.navigateToMainPageViewController()
            }
        }
    }
    
    fileprivate func navigateToLoginViewController()
    {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "loginVC")
        {
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    fileprivate func navigateToMainPageViewController()
    {
        self.performSegue(withIdentifier: "showStartViewController", sender: self)
    }
}

extension OpenAppViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status
        {
        case .restricted, .denied:
            // TODO: Ez így nem lesz a legfainabb!!!
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            navigateToNextPage()
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        }
    }
}




