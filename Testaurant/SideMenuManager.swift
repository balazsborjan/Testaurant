//
//  SideMenuManager.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2018. 02. 01..
//  Copyright © 2018. Kacsak. All rights reserved.
//

import Foundation
import UIKit
import TestaurantBL

class SideMenuManager: NSObject
{
    var delegate: SideMenuDelegate?
    
    static let sideMenusBackgroundAlphaValue: CGFloat = 0.3
    
    lazy var leftSideMenuContent: Array<(menuIcon: UIImage, menuTitle: String, function: () -> Void)> =
        [
            (#imageLiteral(resourceName: "user-icon"), "Profil", self.showProfile),
            (#imageLiteral(resourceName: "settings-icon"), "Beállítások", self.showSettings),
            (#imageLiteral(resourceName: "favourites-icon"), "Kedvencek", self.showFavourites),
            (#imageLiteral(resourceName: "reservations-icon"), "Foglalások", self.showReservations),
            (#imageLiteral(resourceName: "rate-this-app-icon"), "Értékelje az alkalmazást", self.showRateThisApp),
            (#imageLiteral(resourceName: "about-us-icon"), "Rólunk", self.showAboutUs),
            (#imageLiteral(resourceName: "logout-icon"), "Kijelentkezés", self.logout)
        ]
    
    lazy var rightSideMenuContent: Array<(menuTitle: String, function: () -> Void)> =
        [
            ("Profil", self.showProfile),
            ("Beállítások", self.showSettings),
            ("Foglalások", self.showReservations),
            ("Kijelentkezés", self.logout)
        ]
    
    let moreOptionView: UIView =
    {
        let view = UIView()
        view.isUserInteractionEnabled = true
        
        if let window = UIApplication.shared.keyWindow
        {
            view.frame = window.frame
            view.backgroundColor = UIColor.init(white: 0, alpha: SideMenuManager.sideMenusBackgroundAlphaValue)
        }
        
        return view
    }()
    
    let leftSideMenuTableView: UITableView =
    {
        let tableView = UITableView()
        let visualEffectView: UIVisualEffectView!
        
        if let window = UIApplication.shared.keyWindow
        {
            let width = window.frame.width / 4 * 3
            tableView.frame = CGRect(x: (0 - width), y: 0, width: width, height: window.frame.height)
        }
        
        tableView.tintColor = UIColor.white
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        
        let blurEffect = UIBlurEffect(style: .dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        tableView.backgroundView = visualEffectView
        
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        
        return tableView
    }()
    
    let filterView: UIView =
    {
        let view = UIView()
        view.isUserInteractionEnabled = true
        
        if let window = UIApplication.shared.keyWindow
        {
            view.frame = window.frame
            view.backgroundColor = UIColor.init(white: 0, alpha: SideMenuManager.sideMenusBackgroundAlphaValue)
        }
        
        return view
    }()
    
    let rightSideMenuTableView: UITableView =
    {
        let tableView = UITableView()
        let visualEffectView: UIVisualEffectView!
        
        if let window = UIApplication.shared.keyWindow
        {
            let width = window.frame.width / 4 * 3
            tableView.frame = CGRect(x: window.frame.width, y: 0, width: width, height: window.frame.height)
        }
        
        tableView.separatorColor = UIColor.darkGray
        tableView.tintColor = UIColor.black
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        
        let blurEffect = UIBlurEffect(style: .light)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = tableView.frame
        visualEffectView.backgroundColor = UIColor.clear
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.backgroundView = visualEffectView
        
        return tableView
    }()
    
    var moreInfoViewTapGestureRecognizer: UITapGestureRecognizer?
    var filterViewTapGestureRecognizer: UITapGestureRecognizer?
    var leftSideMenuSwipeGestureRecognizer: UISwipeGestureRecognizer?
    var rightSideMenuSwipeGestureRecognizer: UISwipeGestureRecognizer?
    
    override init()
    {
        super.init()
        
        moreInfoViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeMoreInfoView))
        filterViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeFilterView))
        
        leftSideMenuSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeMoreInfoView))
        leftSideMenuSwipeGestureRecognizer?.direction = .left
        
        rightSideMenuSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeFilterView))
        rightSideMenuSwipeGestureRecognizer?.direction = .right
        
        setupLeftSideMenuTableView()
        setupRightSideMenuTableView()
        
        UIApplication.shared.keyWindow?.backgroundColor = UIColor.clear
    }
    
    private func setupLeftSideMenuTableView()
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: leftSideMenuTableView.frame.width, height: leftSideMenuTableView.frame.width / 4 * 3))
        let imageView = UIImageView(image: UserService.Instance.profileImage)
        let textView = UITextView()
        let topSeparatorView = UIView(frame: CGRect(x: 0, y: headerView.frame.height - 1, width: headerView.frame.width, height: 1))
        
        topSeparatorView.backgroundColor = UIColor.init(white: 1, alpha: 0.2)
        
        headerView.addSubview(imageView)
        headerView.addSubview(textView)
        headerView.addSubview(topSeparatorView)
        
        headerView.backgroundColor = UIColor.clear
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.35, constant: 0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 0).isActive = true
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = (imageView.bounds.size.height / 4)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        textView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        textView.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.7, constant: 0).isActive = true
        
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.boldSystemFont(ofSize: 25)
        textView.tintColor = UIColor.white
        textView.textColor = UIColor.white
        textView.textAlignment = .center
        textView.text = "\(String(describing: UserService.Instance.name ?? ""))"
        
        leftSideMenuTableView.tableHeaderView = headerView
        leftSideMenuTableView.tableFooterView = UIView()
        leftSideMenuTableView.tableFooterView?.backgroundColor = UIColor.clear
        
        leftSideMenuTableView.addGestureRecognizer(leftSideMenuSwipeGestureRecognizer!)
        moreOptionView.addGestureRecognizer(moreInfoViewTapGestureRecognizer!)
    }
    
    func showMoreOptionView()
    {
        leftSideMenuTableView.delegate = self
        leftSideMenuTableView.dataSource = self
        
        leftSideMenuTableView.backgroundColor = UIColor.clear
        
        if let window = UIApplication.shared.keyWindow
        {
            window.addSubview(moreOptionView)
            window.addSubview(leftSideMenuTableView)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.moreOptionView.alpha = SideMenuManager.sideMenusBackgroundAlphaValue
                self.leftSideMenuTableView.frame.origin.x = 0
            })
        }
    }
    
    @objc func closeMoreInfoView(_ comp: (() ->Void)? = nil)
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.moreOptionView.alpha = 0
            self.leftSideMenuTableView.frame.origin.x = (0 - self.leftSideMenuTableView.frame.width)
        }, completion: { (true) in
//            comp?()
        })
    }
    
    private func setupRightSideMenuTableView()
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: rightSideMenuTableView.frame.width, height: 110))
        let topSeparatorView = UIView(frame: CGRect(x: 0, y: headerView.frame.height - 1, width: headerView.frame.width, height: 0.5))
        let segmentedControl = UISegmentedControl(frame: headerView.frame)
        
        segmentedControl.insertSegment(withTitle: "Szűrés", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Rendezés", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.blue
            ], for: .selected)
        
        headerView.addSubview(segmentedControl)
        
        topSeparatorView.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
        
        headerView.addSubview(topSeparatorView)
        headerView.backgroundColor = UIColor.clear
        
        rightSideMenuTableView.tableHeaderView = headerView
        rightSideMenuTableView.tableFooterView = UIView()
        rightSideMenuTableView.tableFooterView?.backgroundColor = UIColor.clear
        
        rightSideMenuTableView.addGestureRecognizer(rightSideMenuSwipeGestureRecognizer!)
        filterView.addGestureRecognizer(filterViewTapGestureRecognizer!)
    }
    
    func showFilterView()
    {
        rightSideMenuTableView.delegate = self
        rightSideMenuTableView.dataSource = self
        
        rightSideMenuTableView.backgroundColor = UIColor.clear
        
        if let window = UIApplication.shared.keyWindow
        {
            window.addSubview(filterView)
            window.addSubview(rightSideMenuTableView)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.filterView.alpha = SideMenuManager.sideMenusBackgroundAlphaValue
                self.rightSideMenuTableView.frame.origin.x = window.frame.width / 4
            })
        }
    }
    
    @objc func closeFilterView(_ comp: (() -> ())?)
    {
        if let window = UIApplication.shared.keyWindow
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.filterView.alpha = 0
                self.rightSideMenuTableView.frame.origin.x = window.frame.maxX
            }, completion: { (true) in
//                comp?()
            })
        }
    }
}

extension SideMenuManager : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.leftSideMenuTableView
        {
            return leftSideMenuContent.count
        }
        else
        {
            return rightSideMenuContent.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == self.leftSideMenuTableView
        {
            let cell = createLeftSideMenuCell()
            
            cell.iconImageView.image = leftSideMenuContent[indexPath.row].menuIcon
            cell.titleLabel.text = leftSideMenuContent[indexPath.row].menuTitle
            
            if indexPath.row == (leftSideMenuContent.count - 1)
            {
                cell.separatorInset = .zero
            }
            
            if indexPath.row == leftSideMenuContent.index(where: { (menuIcon: UIImage, menuTitle: String, function: () -> Void) -> Bool in
                return menuTitle == "Kijelentkezés"
            })
            {
                cell.titleLabel.textColor = UIColor.red
            }
            
            return cell
        }
        else if tableView == self.rightSideMenuTableView
        {
            let cell = createRightSideMenuCell()
            
            cell.textLabel?.text = rightSideMenuContent[indexPath.row].menuTitle
            
            if indexPath.row == 3
            {
                cell.separatorInset = .zero
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func createLeftSideMenuCell() -> LeftSideMenuTableViewCell
    {
        let cell = LeftSideMenuTableViewCell()
        
        cell.backgroundColor = UIColor.clear
        cell.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        cell.titleLabel.textColor = UIColor.white
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func createRightSideMenuCell() -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        cell.textLabel?.textColor = UIColor.black
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.leftSideMenuTableView
        {
            self.leftSideMenuContent[indexPath.row].function()
        }
        else if tableView == self.rightSideMenuTableView
        {
            // TODO: Jobb oldali content dictionary-ből meghívni a függvényt...
        }
    }
}

extension SideMenuManager
{
    func showProfile() -> Void
    {
        self.closeMoreInfoView()
        self.delegate?.showProfile()
    }
    
    func showSettings() -> Void
    {
        self.closeMoreInfoView()
        self.delegate?.showSettings()
    }
    
    func showFavourites() -> Void
    {
        self.closeMoreInfoView()
        self.delegate?.showFavourites()
    }
    
    func showAboutUs() -> Void
    {
        self.closeMoreInfoView()
        self.delegate?.showAboutUs()
    }
    
    func showRateThisApp() -> Void
    {
        self.closeMoreInfoView()
        self.delegate?.showRateThisApp()
    }
    
    func showReservations() -> Void
    {
        self.closeMoreInfoView()
        self.delegate?.showReservations()
    }
    
    func logout() -> Void
    {
        self.closeMoreInfoView()
        self.delegate?.logout()
    }
}

protocol SideMenuDelegate : NSObjectProtocol
{
    func showProfile() -> Void
    
    func showSettings() -> Void
    
    func showFavourites() -> Void
    
    func showAboutUs() -> Void
    
    func showRateThisApp() -> Void
    
    func showReservations() -> Void
    
    func logout() -> Void
}












