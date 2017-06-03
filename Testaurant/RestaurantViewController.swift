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
    
    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    
    var peopleCount: [Int] = []
    
    var ratings: [Rating] = []
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    @IBOutlet var galeryCollectionView: UICollectionView!
    
    @IBOutlet var ratingTableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var reservationView: ReservationView!
    
    @IBOutlet weak var peopleCountLabel: UILabel!
    
    @IBOutlet weak var peopleTextField: UITextField!
    
    @IBOutlet weak var reservationDateLebel: UILabel!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var sendRservation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPeopleCount()
        
        imageView.image = image
        
        picker.delegate = self
        picker.dataSource = self
        
        datePicker.minimumDate = Date()
        
        peopleTextField.inputView = picker
        dateTextField.inputView = datePicker
        
        peopleCountLabel.text = String(describing: reservation.selectedPeopleCount!)
        reservationDateLebel.text = reservation.date.toFullFormatString(withYear: false, withLongFormatMonth: true)
        
        datePicker.addTarget(self, action: #selector(reservationDateChanged), for: .valueChanged)
        sendRservation.addTarget(self, action: #selector(sendReservation(_:)), for: .touchUpInside)
        tapGestureRecognizer.addTarget(self, action: #selector(viewTapped(_:)))
        
        reservationView.addGestureRecognizer(tapGestureRecognizer)
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupPeopleCount() {
        
        if let maxpeopleCount = restaurant?.MaxPeopleAtTable {
            
            for i in 1...maxpeopleCount {
                
                peopleCount.append(i)
            }
        }
    }

    
    func viewTapped(_ sender: UITapGestureRecognizer) {
        
        resignTextFieldFirstResponder()
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
    
        resignTextFieldFirstResponder()
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.bringSubview(toFront: reservationView)
        case 1:
            self.view.bringSubview(toFront: galeryCollectionView)
        case 2:
            self.view.bringSubview(toFront: ratingTableView)
        default:
            break
        }
    }
    
    @objc private func reservationDateChanged(_ sender: UIDatePicker) {
        
        reservation.date = sender.date
        self.reservationDateLebel.text = sender.date.toFullFormatString(withYear: false, withLongFormatMonth: true)
    }
    
    private func resignTextFieldFirstResponder() {
        
        peopleTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
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
        
        resignTextFieldFirstResponder()
    }
}

extension RestaurantViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = RatingTableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel?.text = ratings[indexPath.row].userName
        cell.detailTextLabel?.text = String(describing: ratings[indexPath.row].rating)
        
        return cell
    }
}

extension RestaurantViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(self.peopleTextField) {
            
            self.peopleCountLabel.textColor = self.view.tintColor
            
        } else if textField.isEqual(self.dateTextField) {
            
            self.reservationDateLebel.textColor = self.view.tintColor
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.isEqual(self.peopleTextField) {
            
            self.peopleCountLabel.textColor = UIColor.black
            
        } else if textField.isEqual(self.dateTextField) {
            
            self.reservationDateLebel.textColor = UIColor.black
        }
    }
}

extension RestaurantViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return peopleCount.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        reservation.selectedPeopleCount = peopleCount[row]
        self.peopleCountLabel.text = String(describing: (row + 1))
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(describing: peopleCount[row])
    }
}

//extension RestaurantViewController : UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    
//}









