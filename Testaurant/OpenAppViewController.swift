//
//  OpenAppViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 27..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class OpenAppViewController: UIViewController {

    var globalContainerRestaurantsLoadedEventHandler: Disposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalContainer.networkDelegate = self
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        if (FBSDKAccessToken.current() == nil) {
            
            navigateToLoginViewController()
            
        } else {
            
            fetchRestaurants()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        
        globalContainerRestaurantsLoadedEventHandler?.dispose()
    }
    
    private func fetchRestaurants() {
        
        DispatchQueue.global().async {
            
            globalContainer.fetchRestaurants()
        }
    }
    
    fileprivate func showNetworkAlert() {
        
        let alert = UIAlertController(
            title: "Kapcsolódási hiba",
            message: "Kérjük ellenőrizze internetkapcsolatát",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Rendben", style: .default, handler: { (action) in
            
            self.fetchRestaurants()
        }))
        
        alert.addAction(UIAlertAction(title: "Mégsem", style: .cancel, handler: { (action) in
            
            self.navigateToLoginViewController()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func navigateToLoginViewController() {
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "loginVC") {
            
            fetchRestaurants()
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    fileprivate func navigateToMain() {
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "mainViewController") {
            
            globalContainerRestaurantsLoadedEventHandler?.dispose()
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != nil {
            
            if segue.identifier == "openMainVC" {
                
                if let destination = segue.destination as? UINavigationController {
                 
                    destination.visibleViewController?.navigationItem.title = "\(globalContainer.restaurants.count) találat"
                }
            }
        }
    }
}

extension OpenAppViewController : NetworkDelegate {
    
    func restaurantRequestFinished(successed: Bool) {
        
        if successed {
            
            self.navigateToMain()
            
        } else {
            
            self.showNetworkAlert()
        }
    }
    
    func restaurantImageRequestFinished(seccessed: Bool) {
        
        
    }
}






