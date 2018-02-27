//
//  SelectedRestaurantViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2018. 02. 09..
//  Copyright © 2018. Kacsak. All rights reserved.
//

import UIKit
import TestaurantBL

enum RestaurantSection : String
{
    case Reservation = "Asztalfoglalás"
    case Map = "Megközelítés"
    case Gallery = "Galéria"
    case OpeningHours = "Nyitvatartás"
    case Ratings = "Értékelések"
}

class SelectedRestaurantViewController: UIViewController
{
    lazy var reservation = ReservationDto(restaurant: restaurant)
    
    var restaurant: RestaurantDto!
    {
        didSet
        {
            self.backgroundImageView.image = restaurant.MainImage.image
        }
    }
    
    var sectionInfo: Array<(section: RestaurantSection, numberOfRows: Int, isCollapsed: Bool)> =
    [
        (.Reservation, 3, false),
        (.Map, 0, true),
        (.Gallery, 0, true),
        (.OpeningHours, 7, false),
        (.Ratings, 0, true)
    ]
    
    var backgroundImageView: UIImageView = {
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        vev.tag = 10
        
        let imageView = UIImageView()
        
        imageView.addSubview(vev)
        
        return imageView
    }()
    
    let tableView: UITableView = {
        
        let tv = UITableView()
        
        tv.backgroundColor = UIColor.clear
        
        return tv
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupTableView()
        
        self.view.addSubview(tableView)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = restaurant.Name
        
        self.additionalSafeAreaInsets.top = 20
    }
    
    private func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.frame
        
        backgroundImageView.frame = tableView.frame
        backgroundImageView.viewWithTag(10)?.frame = backgroundImageView.frame
        
        tableView.backgroundView = backgroundImageView
        
        tableView.tableFooterView = UIView()
    }
}

extension SelectedRestaurantViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sectionInfo.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        vev.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        
        let headerView = CollapsableHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        headerView.addSubview(vev)
        
        headerView.titleLabel.text = sectionInfo[section].section.rawValue
        headerView.isCollapsed = sectionInfo[section].isCollapsed
        headerView.actionButton.tag = section
        headerView.actionButton.addTarget(self, action: #selector(collapseSection(_:)), for: .touchUpInside)
        
        headerView.sendSubview(toBack: vev)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return CGFloat(40)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sectionInfo[section].isCollapsed ? 0 : sectionInfo[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell!
        
        switch sectionInfo[indexPath.section].section
        {
        case .Reservation:
            cell = createReservationCellBy(row: indexPath.row)
        case .OpeningHours:
            cell = createOpeningHoursCellBy(row: indexPath.row)
        default:
            cell = UITableViewCell()
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath) as? CreateReservationTableViewCell
        {
            cell.textView.keyboardAppearance = UIKeyboardAppearance.dark
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CreateReservationTableViewCell
        {
            cell.textView.resignFirstResponder()
        }
        else if let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? CreateReservationTableViewCell
        {
            cell.textView.resignFirstResponder()
        }
    }
    
    func createReservationCellBy(row: Int) -> CreateReservationTableViewCell
    {
        let cell = CreateReservationTableViewCell(style: .default, reuseIdentifier: nil)
        
        switch row
        {
            case 0:
                cell.type = .Detail
                cell.textLabel?.text = "Személyek száma"
                cell.textView.text = "1"
                cell.peopleCount = generatePeopleCountArrayFromRestaurant()
            case 1:
                cell.type = .Detail
                cell.textLabel?.text = "Dátum"
                cell.textView.text = Date().toFullFormatString(withYear: true, withLongFormatMonth: false)
                cell.peopleCount = generatePeopleCountArrayFromRestaurant()
            case 2:
                cell.type = .Action
                cell.actionButton.addTarget(self, action: #selector(showReservationSendAlert), for: .touchUpInside)
            default:
                break
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func createOpeningHoursCellBy(row: Int) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        switch row
        {
            case 0:
                cell.textLabel?.text = "Hétfő"
                cell.detailTextLabel?.text = restaurant.OpeningHours.Monday
            case 1:
                cell.textLabel?.text = "Kedd"
                cell.detailTextLabel?.text = restaurant.OpeningHours.Tuesday
            case 2:
                cell.textLabel?.text = "Szerda"
                cell.detailTextLabel?.text = restaurant.OpeningHours.Wednesday
            case 3:
                cell.textLabel?.text = "Csütörtök"
                cell.detailTextLabel?.text = restaurant.OpeningHours.Thursday
            case 4:
                cell.textLabel?.text = "Péntek"
                cell.detailTextLabel?.text = restaurant.OpeningHours.Friday
            case 5:
                cell.textLabel?.text = "Szombat"
                cell.detailTextLabel?.text = restaurant.OpeningHours.Saturday
            case 6:
                cell.textLabel?.text = "Vasárnap"
                cell.detailTextLabel?.text = restaurant.OpeningHours.Sunday
            default:
                break
        }
        
        return cell
    }
    
    private func generatePeopleCountArrayFromRestaurant() -> Array<Int>
    {
        var resultArray = Array<Int>()
     
        if self.restaurant.MaxPeopleAtTable > 0
        {
            for i in 1..<(self.restaurant.MaxPeopleAtTable + 1)
            {
                resultArray.append(i)
            }
        }
        else
        {
            for i in 1..<(self.restaurant.MaxPeopleCount + 1)
            {
                resultArray.append(i)
            }
        }
        
        return resultArray
    }
    
    @objc private func collapseSection(_ sender: UIButton)
    {
        let section = sender.tag
        
        if let superView = sender.superview as? CollapsableHeaderView
        {
            superView.isCollapsed = !sectionInfo[section].isCollapsed
        }
        
        var indexPaths = Array<IndexPath>()
        
        for i in 0..<sectionInfo[section].numberOfRows
        {
            let ip = IndexPath(row: i, section: section)
            
            indexPaths.append(ip)
        }
        
        if sectionInfo[section].isCollapsed
        {
            sectionInfo[section].isCollapsed = false
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        else
        {
            sectionInfo[section].isCollapsed = true
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
}

extension SelectedRestaurantViewController : NewReservationInformationDelegate
{
    func reservationDateChanged(newDate: Date!)
    {
        self.reservation.ReservationDate = newDate
    }
    
    func reservationPeopleCountChanged(newPeopleCount: Int)
    {
        self.reservation.SelectedPeopleCount = newPeopleCount
    }
}

extension SelectedRestaurantViewController
{
    @objc fileprivate func showReservationSendAlert()
    {
        let alertController = UIAlertController(
            title: "Foglalás küldése",
            message: "Foglalás részletei:\nAsztal \(reservation.SelectedPeopleCount!) főre\nidőpont: \(reservation.ReservationDate.toFullFormatString(withYear: false, withLongFormatMonth: true) )\nhelyszín: \(restaurant.Name ?? "")",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Mégsem", style: .default, handler: { (action) in
            // Do Nothing
        }))
        
        alertController.addAction(UIAlertAction(title: "Küldés", style: .destructive, handler: { (action) in
            self.sendReservation()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func sendReservation()
    {
        DBService.Instance.Send(reservation: reservation) { (result) in
            if result
            {
                self.showReservationSuccessAlert()
            }
            else
            {
                self.showReservationErrorAlert()
            }
        }
    }
    
    private func showReservationSuccessAlert()
    {
        let alertController = UIAlertController(title: "Sikeres foglalás", message: "Megtekinti foglalásait?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Rendben", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showReservationErrorAlert()
    {
        let alertController = UIAlertController(title: "Sikertelen foglalás", message: "A foglalás küldése közben hiba történt, kérjük próblja meg újra", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Rendben", style: .default, handler: { (action) in
            // Do Nothing
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}



















