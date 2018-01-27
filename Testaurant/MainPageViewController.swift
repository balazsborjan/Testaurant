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

class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var tableHeaderLabel: UILabel!
    
    @IBOutlet var moreInfo: MoreInfoView!
    
    @IBOutlet var filterView: FilterView!
    
    @IBOutlet weak var navigationitem: UINavigationItem!
    
    @IBOutlet weak var showMoreInfoBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var showMoreOptionsBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var showMapBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var edgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet var rightEdgeGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    
    var imageInsets: UIEdgeInsets?
    
    private var panGestureCenter: CGPoint?
    
    private let refresher = UIRefreshControl()
    
    private var restaurants = DBService.Instance.GetRestaurants()
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
            self.tableHeaderLabel.text = "\(filteredRestaurants.count) találat"
        }
    }
    
    var navBarVisualEffectView: UIVisualEffectView? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        refresher.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        searchBar.returnKeyType = .done
        searchBar.setValue("✖️", forKey:"_cancelButtonText")
        
        edgeGestureRecognizer.addTarget(self, action: #selector(showMoreInfoView))
        rightEdgeGestureRecognizer.addTarget(self, action: #selector(showFilterView))
        
        self.tableView.addSubview(refresher)
        
        self.view.addGestureRecognizer(edgeGestureRecognizer)
        self.view.addGestureRecognizer(rightEdgeGestureRecognizer)
        
        setNavigationBar()
        filterView.setFilterTableViewFrame(toNavBarRect: self.navigationController!.navigationBar.frame)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.tableHeaderLabel.text = "\(filteredRestaurants.count) találat"
    }
    
    private func setNavigationBar()
    {
        self.navigationItem.titleView = searchBar
        self.navigationController?.view.addSubview(moreInfo)
        self.navigationController?.view.addSubview(filterView)
        self.navigationItem.rightBarButtonItem = showMoreOptionsBarButtonItem
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.imageInsets = showMapBarButtonItem.imageInsets
        
        showMoreInfoBarButtonItem.target = self
        showMoreInfoBarButtonItem.action = #selector(showMoreInfoView)
        
        showMoreOptionsBarButtonItem.target = self
        showMoreOptionsBarButtonItem.action = #selector(showFilterView)
        
        showMapBarButtonItem.target = self
        showMapBarButtonItem.action = #selector(showRestaurantsOnMap)
        
        
        self.navBarVisualEffectView = VisualEffectViewCreater.CreateVisualEffectView(for: CGRect(
            x: 0,
            y: 0 - self.searchBar.frame.height,
            width: self.view.frame.width,
            height: ((self.navigationController?.navigationBar.frame.maxY)! + self.searchBar.frame.height)), with: .extraLight)
        
        self.view.addSubview(navBarVisualEffectView!)
        
    }
    
    // MARK: Fetch restaurant data (by search)
    @objc private func refreshTableView()
    {
        self.restaurants = DBService.Instance.GetRestaurants()
    }
    
    @IBAction func showReservations(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "showReservations", sender: self)
    }
    
    // MARK: Login/Logout handling
    @IBAction func logout(_ sender: UIButton)
    {
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
    
    private func doLogout()
    {
        fbManager.logOut()
        moreInfo.hide(completion: showLoginViewController)
    }
    
    func showLoginViewController(logoutSuccessed successed: Bool) -> Void
    {
        if successed
        {
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "loginVC")
            {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    // MARK: Open/Close Settings view
    @objc fileprivate func showMoreInfoView()
    {
        self.filterView.hide(completion: nil)
        self.moreInfo.show()
    }
    
    private func closeExtraViews()
    {
        moreInfo.hide(completion: nil)
        filterView.hide(completion: nil)
    }
    
    @objc fileprivate func showFilterView()
    {
        self.moreInfo.hide(completion: nil)
        self.filterView.show()
    }
    
    @objc fileprivate func showRestaurantsOnMap()
    {
        self.performSegue(withIdentifier: "showMap", sender: self)
    }
    
    private func switchMainViewAccessibility(to isEnabled: Bool)
    {
        var enabled = isEnabled
        
        if moreInfo.frame.maxX > 0 || filterView.frame.origin.x < self.view.frame.maxX
        {
            enabled = false
        }
        
        searchBar.isUserInteractionEnabled = enabled
        
        tableView.isScrollEnabled = enabled
        tableView.allowsSelection = enabled
    }
    
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredRestaurants.count
//        return tableView == self.tableView ? filteredRestaurants.count : globalContainer.filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "searchRestaurantCell")
        {
            cell.backgroundColor = tableView.backgroundColor
            
            if let restaurantCell = cell as? MainPageTableViewCell
            {
                let currentRestaurant = filteredRestaurants[indexPath.row]
                
                restaurantCell.nameLabel?.text = currentRestaurant.Name
                restaurantCell.avarageRatingLabel?.text = "4,4"
                restaurantCell.mainPictureImageView.sd_setImage(with: DBService.Instance.GetMainImageUrl(for: currentRestaurant), placeholderImage: nil)
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
//        let currentOption = globalContainer.filterOptions[indexPath.row]
//
//        if currentOption.isSimple
//        {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "filterSwitchCell") as? FilterSwitchTableViewCell
//            {
//                cell.optionLabel.text = currentOption.option
//                cell.optionSwitch.isOn = currentOption.isActive
//
//                return cell
//            }
//        }
//        else
//        {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "filterMultiCell") as? FilterMultiTableViewCell
//            {
//                cell.optionLabel.text = currentOption.option
//                cell.selectedValueLabel.text = currentOption.selectedValue
//
//                return cell
//            }
//        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.isEqual(self.tableView)
        {
            searchBar.resignFirstResponder()
            
            if let cell = tableView.cellForRow(at: indexPath) as? MainPageTableViewCell
            {
                self.performSegue(withIdentifier: "openRestaurant", sender: cell)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        searchBar.resignFirstResponder()
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
        closeExtraViews()
        
        self.navigationItem.title = ""
        
        if let identifier = segue.identifier
        {
            if let cell = sender as? MainPageTableViewCell
            {
                if identifier == "openRestaurant"
                {
                    if let indexPath = self.tableView.indexPath(for: cell)
                    {
                        let selectedRestaurant = filteredRestaurants[indexPath.row]
                        
                        if let restaurantViewController = segue.destination as? RestaurantViewController
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

extension MainPageViewController : UISearchBarDelegate {
    
    func maximizeSearchBar() {
        
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setRightBarButtonItems(nil, animated: true)
    }
    
    func minimizeSearchBar() {
        
        self.navigationItem.setLeftBarButton(
            UIBarButtonItem(image: #imageLiteral(resourceName: "user-icon"), style: .plain, target: self, action: #selector(showMoreInfoView)),
            animated: true
        )
        
        self.navigationItem.setRightBarButtonItems(
            [
                UIBarButtonItem(image: #imageLiteral(resourceName: "settings-icon-new-new"), style: .plain, target: self, action: #selector(showFilterView)),
                UIBarButtonItem(image: #imageLiteral(resourceName: "map-icon"), style: .plain, target: self, action: #selector(showRestaurantsOnMap))
            ],
            animated: true
        )
        
        self.navigationItem.rightBarButtonItems![1].imageInsets = self.imageInsets!
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        maximizeSearchBar()
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        minimizeSearchBar()
        
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
