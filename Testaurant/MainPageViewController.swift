//
//  MainPageViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 04..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import Foundation
import TestaurantBL
import PreviewTransition
import NVActivityIndicatorView
import UIImageColors

class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource //PTTableViewController
{
    // Network session
    var expectedContentLength = 0
    var buffer:NSMutableData = NSMutableData()
    // ##############
    
    @IBOutlet var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var showMoreInfoBarButtonItem: UIBarButtonItem!
    
    var showMoreOptionsBarButtonItem: UIBarButtonItem!
    
    var showMapBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var edgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet var rightEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    var imageInsets: UIEdgeInsets?
    
    private var panGestureCenter: CGPoint?
    
    private let refresher = UIRefreshControl()
    
    private var restaurants = Array<RestaurantDto>()
    {
        didSet
        {
            filteredRestaurants = restaurants
        }
    }
    
    private var filteredRestaurants = Array<RestaurantDto>()
    {
        didSet
        {
            self.tableView?.reloadData()
            refresher.endRefreshing()
        }
    }
    
    let sideMenuManager = SideMenuManager()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        sideMenuManager.delegate = self
        
        setNavigationBar()
//        setupTableViewBackgroundView()
        
        refresher.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        self.tableView.refreshControl = refresher
        
        edgeGestureRecognizer.addTarget(self, action: #selector(showMoreInfoView))
        rightEdgeGestureRecognizer.addTarget(self, action: #selector(showFilterView))
        
        self.view.addGestureRecognizer(edgeGestureRecognizer)
        self.view.addGestureRecognizer(rightEdgeGestureRecognizer)
        
        fetchRestaurants()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Helyszínek"
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.navigationItem.title = ""
    }
    
    private func setNavigationBar()
    {
        self.showMoreInfoBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "left-menu-icon"), style: .done, target: self, action: #selector(showMoreInfoView))
        self.showMapBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "map-icon"), style: .done, target: self, action: #selector(showRestaurantsOnMap))
        self.showMoreOptionsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings-icon-new-new"), style: .done, target: self, action: #selector(showFilterView))
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.backBarButtonItem = nil
        
        self.navigationItem.leftBarButtonItem = showMoreInfoBarButtonItem
        self.navigationItem.rightBarButtonItems = [showMoreOptionsBarButtonItem, showMapBarButtonItem]
        
        UISearchBar.appearance().tintColor = UIColor.darkText
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Helyszín keresése"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupTableViewBackgroundView()
    {
        let bgView = UIView(frame: self.view.frame)
        let imageView = UIImageView(frame: bgView.frame)
        let veView = UIVisualEffectView(frame: imageView.frame)
        let veView2 = UIVisualEffectView(frame: imageView.frame)
        
//        bgView.backgroundColor = UIColor.blue
        
//        imageView.image = #imageLiteral(resourceName: "background")
        imageView.contentMode = .scaleAspectFill
        
        veView.effect = UIBlurEffect(style: .dark)
        veView.alpha = 0.5
        
        veView2.effect = UIBlurEffect(style: .light)
        
        imageView.addSubview(veView2)
        imageView.addSubview(veView)
        bgView.addSubview(imageView)
        
        self.tableView.backgroundView = bgView
    }
    
    private func fetchRestaurants()
    {
        NVActivityIndicatorPresenter.sharedInstance.setMessage("Helyszínek betöltése")
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        DBService.Instance.GetRestaurants { (result) in
            self.restaurants = result
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    // MARK: Fetch restaurant data (by search)
    @objc private func refreshTableView()
    {
        fetchRestaurants()
    }
    
    // MARK: Open/Close Settings view
    @objc fileprivate func showMoreInfoView(sender: Any)
    {
        sideMenuManager.showMoreOptionView()        
    }
    
    @objc fileprivate func showFilterView()
    {
        sideMenuManager.showFilterView()
    }
    
    @objc fileprivate func showRestaurantsOnMap()
    {
        self.performSegue(withIdentifier: "showMap", sender: self)
    }
    
    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "searchRestaurantCell")
        {
            if let restaurantCell = cell as? MainPageTableViewCell
            {
                let currentRestaurant = filteredRestaurants[indexPath.row]

                restaurantCell.nameTextView.text = currentRestaurant.Name
                restaurantCell.avarageRatingLabel.setLabelAttributes(text: "\(currentRestaurant.AvgRating)", image: #imageLiteral(resourceName: "rating-icon"))
                restaurantCell.freeSpaceLabel.setLabelAttributes(text: "\(currentRestaurant.FreeSpace)", image: #imageLiteral(resourceName: "free-table-icon"))

                restaurantCell.mainPictureImageView.sd_setShowActivityIndicatorView(true)

                restaurantCell.mainPictureImageView.sd_setImage(with: DBService.Instance.GetMainImageUrl(for: currentRestaurant), completed: { (image, error, imageCachedType, url) in
//                    restaurantCell.backgroundImageView.image = image
                    
//                    image?.getColors({ (colors) in
//                        restaurantCell.shadowColor = colors.primary
//                    })
                    
                    DBService.Instance.Restaurants.filter{ $0.ID == currentRestaurant.ID }.first?.MainImage.image = image
                })
            }

            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.isEqual(self.tableView)
        {
            if let cell = tableView.cellForRow(at: indexPath) as? MainPageTableViewCell
            {
                self.performSegue(withIdentifier: "proba", sender: cell)
            }
        }
    }
    
    func filterRestaurants(by filterText: String?)
    {
        if filterText == nil || filterText!.isEmpty
        {
            filteredRestaurants = restaurants
        }
        else
        {
            filteredRestaurants = restaurants.filter { ($0.Name?.contains(filterText!))! }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let identifier = segue.identifier
        {
            if let cell = sender as? MainPageTableViewCell
            {
                if let indexPath = self.tableView.indexPath(for: cell)
                {
                    let selectedRestaurant = filteredRestaurants[indexPath.row]
                    
                    if identifier == "proba"
                    {
                        if let destVC = segue.destination as? ProbaViewController
                        {
                            destVC.restaurant = selectedRestaurant
                        }
                    }
                    else if identifier == "openRestaurant"
                    {
                        if let restaurantViewController = segue.destination as? SelectedRestaurantViewController//RestaurantViewController
                        {
                            restaurantViewController.restaurant = selectedRestaurant
                        }
                    }
                }
            }
            else
            {
                if identifier == "showMap"
                {
                    if let mapViewController = segue.destination as? MapViewController
                    {
                        mapViewController.restaurants = filteredRestaurants.filter { $0.ID! < 9 }
                    }
                }
            }
        }
    }
}

extension MainPageViewController : UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        if searchController.searchBar.text == nil || searchController.searchBar.text == ""
        {
            self.filterRestaurants(by: "")
        }
        else
        {
            self.filterRestaurants(by: searchController.searchBar.text)
        }
    }
}

extension MainPageViewController : SideMenuDelegate
{
    func showFavourites()
    {
        
    }
    
    func showAboutUs()
    {
        
    }
    
    func showRateThisApp()
    {
        
    }
    
    func showProfile()
    {
        
    }
    
    func showSettings()
    {
        
    }
    
    func showReservations()
    {
        self.performSegue(withIdentifier: "showReservations", sender: self)
    }
    
    func logout()
    {
        // MARK: Figyelmeztetés
        let alert = UIAlertController(title: "Biztosan kijelentkezik?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Kijelentkezés", style: .destructive, handler: { (action) in
            self.doLogout()
        }))
        
        alert.addAction(UIAlertAction(title: "Mégsem", style: .default, handler: { (action) in
            // Do nothing
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func doLogout()
    {
        UserService.Instance.logout {
            fbManager.logOut()
            if let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "loginVC")
            {
                self.present(viewcontroller, animated: true, completion: nil)
            }
        }
    }
}

extension MainPageViewController : UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.filterRestaurants(by: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.filterRestaurants(by: "")
        searchBar.text = ""
        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
}

//extension MainPageViewController : URLSessionDownloadDelegate
//{
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
//    {
//        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
//
//        print(percentage)
//
//        DispatchQueue.main.async {
//            self.progressBar.shapeLayer.strokeEnd = percentage
//        }
//    }
//}

//extension MainPageViewController : URLSessionDataDelegate
//{
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
//    {
//        if error == nil
//        {
//
//        }
//    }
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
//    {
//        buffer.append(data)
//        let percentageDownloaded = CGFloat(buffer.length) / CGFloat(expectedContentLength)
//        self.progressBar.shapeLayer.strokeEnd = percentageDownloaded
//    }
//
//    @nonobjc func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void)
//    {
//        expectedContentLength = Int(response.expectedContentLength)
//        print(expectedContentLength)
////        completionHandler(URLSession.ResponseDisposition.Allow)
//    }
//
//    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession)
//    {
//        self.progressBar.shapeLayer.strokeEnd = 1.0
//    }
//}















