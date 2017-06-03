//
//  RestaurantViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 31..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {

    var restaurant: Restaurant!
    
    let reservation = Reservation()
    
    var ratings: [Rating] = []
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    @IBOutlet weak var reservationTableView: UITableView!
    
    @IBOutlet var galeryCollectionView: UICollectionView!
    
    @IBOutlet var ratingTableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var sendReservationButton: UIButton!
    
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footerView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.reservationTableView.frame.width,
            height: (reservationTableView.frame.maxY) - (reservationTableView.frame.minX + 120))
        
        imageView.image = image
        
        sendReservationButton.addTarget(self, action: #selector(sendReservation(_:)), for: .touchUpInside)
        
        tapGestureRecognizer.addTarget(self, action: #selector(viewTapped(_:)))
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func viewTapped(_ sender: UITapGestureRecognizer) {
        
        resignAllCellsFirstResponder()
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
    
        resignAllCellsFirstResponder()
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.bringSubview(toFront: reservationTableView)
        case 1:
            self.view.bringSubview(toFront: galeryCollectionView)
        case 2:
            self.view.bringSubview(toFront: ratingTableView)
        default:
            break
        }
    }
    
    @objc private func sendReservation(_ sender: UIButton) {
        
        let alert = UIAlertController(
            title: "Foglalás küldése",
            message: "Foglalás részletei:\nAsztal \(reservation.selectedPeopleCount) főre\nidőpont: \(reservation.date?.toString() ?? "")\nhelyszín: \(restaurant.Name ?? "")",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Küldés", style: .default, handler: { (action) in
            
            //DO NOTHING -> Majd itt kell elküldeni a dolgokat
        }))
        
        alert.addAction(UIAlertAction(title: "Mégsem", style: .destructive, handler: { (action) in
            
            //DO NOTHING
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func addTargetToSendReservationButton(button: UIButton) {
        
        button.addTarget(self, action: #selector(sendReservation), for: .touchUpInside)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        resignAllCellsFirstResponder()
    }
}

extension RestaurantViewController : UITableViewDelegate, UITableViewDataSource {
    
    func resignAllCellsFirstResponder() {
        
        if let cell = reservationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ReservationPeopleTableViewCell {
            
            cell.textField.resignFirstResponder()
            
        }
        if let cell = reservationTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ReservationDateTableViewCell {
            
            cell.textField.resignFirstResponder()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.isEqual(self.reservationTableView) {
            
            return 4
            
        } else if tableView.isEqual(self.ratingTableView) {
            
            return ratings.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.isEqual(self.reservationTableView) {
            
            if indexPath.row == 0 {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "reservationPeopleCell") as? ReservationPeopleTableViewCell {
                    
                    cell.restaurant = self.restaurant
                    cell.reservation = self.reservation
                    
                    return cell
                }
                
            } else if indexPath.row == 1 {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "reservationDateCell") as? ReservationDateTableViewCell {
                    
                    cell.reservation = self.reservation
                    return cell
                }
            }
            
        } else if tableView.isEqual(self.ratingTableView) {
            
            let cell = RatingTableViewCell(style: .value1, reuseIdentifier: nil)
            
            cell.textLabel?.text = ratings[indexPath.row].userName
            cell.detailTextLabel?.text = String(describing: ratings[indexPath.row].rating)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

//extension RestaurantViewController : UIPickerViewDelegate, UIPickerViewDataSource {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        
//        return peopleCount.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        reservation.selectedPeopleCount = peopleCount[row]
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        
//        return String(describing: peopleCount[row])
//    }
//}

//extension RestaurantViewController : UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    
//}









