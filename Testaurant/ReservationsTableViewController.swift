//
//  ReservationsTableViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 11..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import TestaurantBL

class ReservationsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var allReservations = Array<ReservationDto>()
    {
        didSet
        {
            self.tableView.reloadData()
            refresher.endRefreshing()
        }
    }
    
    var activeReservations: Array<ReservationDto>
    {
        get
        {
            return allReservations.filter { $0.ReservationDate >= Date() }
        }
    }
    
    var pastReservations: [ReservationDto]
    {
        get
        {
            return allReservations.filter { $0.ReservationDate < Date() }
        }
    }
    
    var navBarVisualEffectView: UIVisualEffectView? = nil
    
    let refresher = UIRefreshControl()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        refresher.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        self.tableView.addSubview(refresher)
        
        DBService.Instance.GetReservations { (result) in
            self.allReservations = result
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Foglalásaim"
    }
    
    @objc private func refreshTableView()
    {
        DBService.Instance.GetReservations { (result) in
            self.allReservations = result
        }
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int
     {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let titleLabel = UILabel()
//        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(25))
//        titleLabel.font = UIFont.systemFont(ofSize: CGFloat(25), weight: UIFont.Weight.semibold)
//        titleLabel.backgroundColor = self.tableView.backgroundColor
//
//        switch section
//        {
//        case 0:
//            titleLabel.text = "  Aktív foglalások"
//        case 1:
//            titleLabel.text = "  Korábbi foglalások"
//        default:
//            titleLabel.text = nil
//        }
//
//        return titleLabel
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allReservations.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCell", for: indexPath) as? ReservationTableViewCell
        {
            var currentReservation: ReservationDto!
            
            currentReservation = allReservations[indexPath.row]
            
//            switch indexPath.section
//            {
//                case 0:
//                    currentReservation = activeReservations[indexPath.row]
//                case 1:
//                    currentReservation = pastReservations[indexPath.row]
//                default:
//                    break
//            }
            
            cell.restaurantNameLabel.text = DBService.Instance.Restaurants.filter{ $0.ID! == currentReservation.RestaurantID }.first?.Name
            cell.selectedPeopleCountLabel.text = String(describing: currentReservation.SelectedPeopleCount!)
            cell.reservationDateLabel.text = currentReservation.ReservationDate.toFullFormatString(withYear: true, withLongFormatMonth: true)
            cell.restaurantImageView.image = DBService.Instance.Restaurants.filter{ $0.ID! == currentReservation.RestaurantID }.first?.MainImage.image
            
            cell.selectionStyle = .none
            
            return cell
        }

        return UITableViewCell()
    }
}












