//
//  MainPageViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 04..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Foundation

class MainPageViewController: UITableViewController {
    
    var moreInfoChangeStateEventHandler: Disposable?
    
    var globalContainerRestaurantsLoadedEventHandler: Disposable?
    
    @IBOutlet weak var tableHeaderLabel: UILabel!
    
    @IBOutlet var moreInfo: MoreInfoView!
    
    @IBOutlet var moreOption: MoreOptionView!
    
    let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    @IBOutlet weak var navigationitem: UINavigationItem!
    
    @IBOutlet weak var showMoreInfoBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var showMoreOptionsBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!

    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var edgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    private var panGestureCenter: CGPoint?
    
    private let refresher = UIRefreshControl()
    
    private var restaurants: [Restaurant]! = [] {
        didSet {
            filteredRestaurants = restaurants
        }
    }
    
    private var filteredRestaurants: [Restaurant]! = [] {
        
        didSet {
            
            self.tableView?.reloadData()
            refresher.endRefreshing()
            self.tableHeaderLabel.text = "\(filteredRestaurants.count) találat"
        }
    }
    
    private let moreInfoTableViewCellIdentifiers = ["showProfileRow", "showReservationsRow", "showSettingsRow", "emptyRow", "logoutRow"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher.attributedTitle = NSAttributedString(string: "Éttermek betöltése")
        refresher.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        searchBar.returnKeyType = .done
        searchBar.setValue("✖️", forKey:"_cancelButtonText")
        
        moreInfoChangeStateEventHandler = moreInfo.didChangeStateEvent.addHandler(target: self, handler: switchMainViewAccessibility)
        
        globalContainerRestaurantsLoadedEventHandler = globalContainer.restaurantsLoadedEvent.addHandler(target: self, handler: populateTableView)
        
        setupMoreOptionView()
        
        tapGestureRecognizer.addTarget(self, action: #selector(closeMoreInfrmationView(_:)))
        edgeGestureRecognizer.addTarget(self, action: #selector(showMoreInformationView(_:)))
        
        self.tableView.contentOffset.y = 0 - 100
        self.tableView.addSubview(refresher)
        
        self.view.addGestureRecognizer(edgeGestureRecognizer)
        
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableHeaderLabel.text = "\(filteredRestaurants.count) találat"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.sendSubview(toBack: visualEffectView)
        
        if globalContainer.restaurants.count != self.restaurants.count {
            
            self.restaurants = globalContainer.restaurants
        }
    }
    
    deinit {
        
        moreInfoChangeStateEventHandler?.dispose()
        globalContainerRestaurantsLoadedEventHandler?.dispose()
    }
    
    private func setNavigationBar() {
        
        self.navigationItem.titleView = searchBar
        self.navigationController?.view.addSubview(moreInfo)
        self.navigationController?.view.insertSubview(moreOption, at: 2)
        self.navigationItem.rightBarButtonItem = showMoreOptionsBarButtonItem
        
        visualEffectView.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.insertSubview(visualEffectView, at: self.navigationController!.navigationBar.subviews.count)
    }
    
    private func setupMoreOptionView() {
        
        moreOption.setFrame(by: CGRect(x: 0, y: 0 - moreOption.frame.height, width: self.view.frame.width, height: self.searchBar.frame.height))
    }
    
    private func setMoreInfoButtonAction(for button: UIButton, with identifier: String) {
        
        switch identifier {
        case "logoutRow":
            button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        case "showReservationsRow":
            button.addTarget(self, action: #selector(showReservations), for: .touchUpInside)
        default:
            break
        }
    }
    
    // MARK: Fetch restaurant data (by search)
    
    private func populateTableView() {
        
        self.restaurants = globalContainer.restaurants
    }
    
    @objc private func refreshTableView() {
        
        globalContainer.fetchRestaurants()
    }
    
    // MARK: Login/Logout handling
    
    @objc private func logout() {
        
        // MARK: Figyelmeztetés
        let alert = UIAlertController(title: "Biztosan kijelentkezik?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Kijelentkezés", style: .destructive, handler: { (action) in
            self.doLogout()
        }))
        
        alert.addAction(UIAlertAction(title: "Mégsem", style: .default, handler: { (action) in
            // Do nothing
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func doLogout() {
        
        fbManager.logOut()
        
        moreInfo.hide(completion: showLoginViewController)
    }
    
    func showLoginViewController(logoutSuccessed successed: Bool) -> Void {
        
        if successed {
            
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "loginVC") {
                
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: Open/Close Settings view
    
    @objc private func showMoreInformationView(_ sender: Any?) {
        
        moreInfo.show()
    }
    
    @objc private func closeMoreInfrmationView(_ sender: Any?) {
        
        moreInfo.hide(completion: nil)
    }
    
    @IBAction func moveMoreOptionView(_ sender: Any) {
        
        if self.moreOption.frame.origin.y < 0 {
            
            showMoreOptionView()
            
        } else {
            
            closeMoreOptionView()
        }
    }
    
    func showMoreOptionView() {
    
        showMoreOptionsBarButtonItem.image = #imageLiteral(resourceName: "up-arrow-icon")
        
        UIView.animate(withDuration: 0.2) {
            self.moreOption.frame.origin.y = (self.navigationController?.navigationBar.frame.maxY)!
        }
    }
    
    private func closeMoreOptionView() {
        
        showMoreOptionsBarButtonItem.image = #imageLiteral(resourceName: "down-arrow-icon")
        
        UIView.animate(withDuration: 0.2) {
            self.moreOption.frame.origin.y = 0 - self.moreOption.frame.height
        }
    }
    
    private func switchMainViewAccessibility(to isEnabled: Bool) {
        
        showMoreOptionsBarButtonItem.isEnabled = isEnabled
        
        searchBar.isUserInteractionEnabled = isEnabled
        
        tableView.isScrollEnabled = isEnabled
        tableView.allowsSelection = isEnabled
        
        switch isEnabled {
        case true:
            self.view.gestureRecognizers = self.view.gestureRecognizers?.filter { $0 !== tapGestureRecognizer }
        case false:
            self.view.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc private func showMap(_ sender: UILabel) {
        
        self.performSegue(withIdentifier: "showMap", sender: sender)
    }
    
    @objc private func showReservations() {
        
        self.performSegue(withIdentifier: "showReservations", sender: self)
    }
    
    // MARK: TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView == self.tableView ? filteredRestaurants.count : 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
        
            if let cell = tableView.dequeueReusableCell(withIdentifier: "searchRestaurantCell") {
        
                cell.backgroundColor = tableView.backgroundColor
                
                if let restaurantCell = cell as? MainPageTableViewCell {
                    
                    let currentRestaurant = filteredRestaurants[indexPath.row]
                    
                    restaurantCell.nameLabel?.text = currentRestaurant.Name
                    restaurantCell.avarageRatingLabel?.text = "4,4"
                    
                    restaurantCell.mainPictureImageView.sd_setImage(
                        with: URL(string: currentRestaurant.MainImageURL!),
                        completed: { (image, error, cacheType, url) in
                            
                            if error != nil {
                                
                                print("Error")
                                
                            } else {
                                
                                currentRestaurant.image = image
                            }
                    })
                }
                
                cell.selectionStyle = .none
                
                return cell
            }
            
        } else if tableView == self.moreInfo.tableView {
            
            if indexPath.row < moreInfoTableViewCellIdentifiers.count {
                
                let identifier = moreInfoTableViewCellIdentifiers[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
                
                if !identifier.contains("empty") {
                    
                    setMoreInfoButtonAction(for: cell.contentView.subviews[0] as! UIButton, with: identifier)
                }
                
                return cell
                
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBar.resignFirstResponder()
        
        if let cell = tableView.cellForRow(at: indexPath) as? MainPageTableViewCell {
            
            self.performSegue(withIdentifier: "openRestaurant", sender: cell)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        searchBar.resignFirstResponder()
        closeMoreOptionView()
    }
    
    func filterRestaurants(by filterText: String?) {
        
        if filterText == nil || filterText!.isEmpty {
            
            filteredRestaurants = restaurants
            
        } else {
            
            filteredRestaurants = restaurants.filter { ($0.Name?.contains(filterText!))! }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        closeMoreInfrmationView(nil)
        closeMoreOptionView()
        
        self.navigationItem.title = ""
        
        if let cell = sender as? MainPageTableViewCell {
            
            if let identifier = segue.identifier {
                
                if identifier == "openRestaurant" {
                    
                    if let indexPath = self.tableView.indexPath(for: cell) {
                        
                        let selectedRestaurant = filteredRestaurants[indexPath.row]
                        
                        if let restaurantViewController = segue.destination as? RestaurantViewController {
                            
                            restaurantViewController.restaurant = selectedRestaurant
                            restaurantViewController.navigationItem.title = selectedRestaurant.Name
                        }
                    }
                }
            }
            
        } else {
            
            if let identifier = segue.identifier {
                
                if identifier == "showAllRestaurantOnMap" {
                    
                    if let mapViewController = segue.destination as? MapViewController {
                        
                        mapViewController.restaurants = filteredRestaurants.filter { $0.ID! < 9 }
                    }
                }
            }
        }
    }
}

extension MainPageViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterRestaurants(by: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.filterRestaurants(by: "")
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
