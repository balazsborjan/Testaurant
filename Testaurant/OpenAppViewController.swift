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
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        fetchRestaurants()
        
        if (FBSDKAccessToken.current() == nil) {
            
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "loginVC") {
                
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        } else {
            
            globalContainerRestaurantsLoadedEventHandler = globalContainer.restaurantsLoadedEvent.addHandler(target: self, handler: navigateToMain)
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
    
    private func navigateToMain() {
        
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
