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

class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var moreInfoChangeStateEventHandler: Disposable?
    
    var globalContainerRestaurantsLoadedEventHandler: Disposable?
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var tableHeaderLabel: UILabel!
    
    @IBOutlet var moreInfo: MoreInfoView!
    
    @IBOutlet var moreOption: MoreOptionView!
    
    @IBOutlet weak var navigationitem: UINavigationItem!
    
    @IBOutlet weak var showMoreInfoBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var showMoreOptionsBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
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
    
    var navBarVisualEffectView: UIVisualEffectView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        searchBar.returnKeyType = .done
        searchBar.setValue("✖️", forKey:"_cancelButtonText")
        
        moreInfoChangeStateEventHandler = moreInfo.didChangeStateEvent.addHandler(target: self, handler: switchMainViewAccessibility)
        
        globalContainerRestaurantsLoadedEventHandler = globalContainer.restaurantsLoadedEvent.addHandler(target: self, handler: populateTableView)
        
        tapGestureRecognizer.addTarget(self, action: #selector(closeMoreInfrmationView(_:)))
        edgeGestureRecognizer.addTarget(self, action: #selector(showMoreInfoView(_:)))
        
        self.tableView.addSubview(refresher)
        
        self.view.addGestureRecognizer(edgeGestureRecognizer)
        
        setupMoreOptionView()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableHeaderLabel.text = "\(filteredRestaurants.count) találat"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        self.navBarVisualEffectView = VisualEffectViewCreater.createVisualEffectView(for: CGRect(
            x: 0,
            y: 0 - self.searchBar.frame.height,
            width: self.view.frame.width,
            height: ((self.navigationController?.navigationBar.frame.maxY)! + self.searchBar.frame.height)), with: .extraLight)
        
        self.view.addSubview(navBarVisualEffectView!)
        
    }
    
    private func setupMoreOptionView() {
        
        moreOption.setFrame(by: CGRect(x: 0, y: 0 - moreOption.frame.height, width: self.view.frame.width, height: self.searchBar.frame.height))
    }
    
    // MARK: Fetch restaurant data (by search)
    
    private func populateTableView() {
        
        self.restaurants = globalContainer.restaurants
    }
    
    @IBAction func showMoreInformationView(_ sender: UIBarButtonItem) {
        
        showMoreInfoView(sender)
    }
    
    @objc private func refreshTableView() {
        
        globalContainer.fetchRestaurants()
    }
    
    @IBAction func showReservations(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "showReservations", sender: self)
    }
    // MARK: Login/Logout handling
    
    @IBAction func logout(_ sender: UIButton) {
    
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
    
    @objc private func showMoreInfoView(_ sender: Any?) {
        
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
        
        UIView.animate(withDuration: 0.25, animations: {
            self.navBarVisualEffectView?.frame.origin.y = 0
        })
    }
    
    private func closeMoreOptionView() {
        
        showMoreOptionsBarButtonItem.image = #imageLiteral(resourceName: "down-arrow-icon")
        
        UIView.animate(withDuration: 0.2) {
            self.moreOption.frame.origin.y = 0 - self.moreOption.frame.height
        }
        
        UIView.animate(withDuration: 0.15, animations: {
            self.navBarVisualEffectView?.frame.origin.y = 0 - self.searchBar.frame.height
        })
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
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView == self.tableView ? filteredRestaurants.count : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        searchBar.resignFirstResponder()
        
        if let cell = tableView.cellForRow(at: indexPath) as? MainPageTableViewCell {
            
            self.performSegue(withIdentifier: "openRestaurant", sender: cell)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
        
        if let identifier = segue.identifier {
            
            if let cell = sender as? MainPageTableViewCell {
            
                if identifier == "openRestaurant" {
                    
                    if let indexPath = self.tableView.indexPath(for: cell) {
                        
                        let selectedRestaurant = filteredRestaurants[indexPath.row]
                        
                        if let restaurantViewController = segue.destination as? RestaurantViewController {
                            
                            restaurantViewController.restaurant = selectedRestaurant
                        }
                    }
                }
                
            } else {
                
                if identifier == "showMap" {
                    
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
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        tableView.setContentOffset(tableView.contentOffset, animated: false)
        
        return true
    }
}
