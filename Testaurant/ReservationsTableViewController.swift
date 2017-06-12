//
//  ReservationsTableViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 11..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class ReservationsTableViewController: UITableViewController {

    let activeReservations = User.instance.reservations.filter { $0.date > Date() }
    
    let pastReservations = User.instance.reservations.filter { $0.date < Date() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return activeReservations.count
        case 1:
            return pastReservations.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 28))
        
        view.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: view.frame.width, height: view.frame.height))
        
        switch section {
        case 0:
            label.text = "Aktuális foglalások"
        case 1:
            label.text = "Korábbi foglalások"
        default:
            return nil
        }
        
        view.addSubview(label)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 28
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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












