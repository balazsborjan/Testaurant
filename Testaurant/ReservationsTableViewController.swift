//
//  ReservationsTableViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 11..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class ReservationsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var activeReservations: [Reservation] {
        
        get {
            return User.instance.reservations.filter { $0.date >= Date() }
        }
    }
    
    var pastReservations: [Reservation] {
        
        get {
            
            return User.instance.reservations.filter { $0.date < Date() }
        }
    }
    
    var navBarVisualEffectView: UIVisualEffectView? = nil
    
    let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = true
        
        navBarVisualEffectView = VisualEffectViewCreater.createVisualEffectView(
            for: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.navigationController!.navigationBar.frame.maxY), with: .extraLight)
        
        self.view.addSubview(navBarVisualEffectView!)
        
        refresher.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        self.tableView.addSubview(refresher)
    }
    
    @objc private func refreshTableView() {
        
        User.instance.getReservations(completion: reservationsUpdated)
    }
    
    private func reservationsUpdated() -> Void {
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return activeReservations.count
        case 1:
            return pastReservations.count
        default:
            return 0
        }
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCell", for: indexPath) as? ReservationTableViewCell {
            
            var currentReservation: Reservation!
            
            switch indexPath.section {
            case 0:
                currentReservation = activeReservations[indexPath.row]
            case 1:
                currentReservation = pastReservations[indexPath.row]
            default:
                break
            }
            
            cell.restaurantNameLabel.text = currentReservation.restaurant.Name
            cell.selectedPeopleCountLabel.text = String(describing: currentReservation.selectedPeopleCount!)
            cell.reservationDateLabel.text = currentReservation.date.toFullFormatString(withYear: true, withLongFormatMonth: true)
            cell.restaurantImageView.image = currentReservation.restaurant.image
            
            return cell
        }

        return UITableViewCell()
    }
}












