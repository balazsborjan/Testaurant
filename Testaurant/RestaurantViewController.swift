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
    
    var ratings: [Rating] = [] {
        didSet{
            self.ratingTableView.reloadData()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var openingTimeLabel: UIButton!
    
    @IBOutlet weak var addressLabel: UIButton!
    
    @IBOutlet var contentView: SelectedRestaurantContentView!
    
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
        
        self.navigationItem.title = restaurant.Name
        
        imageView.image = restaurant.image
        
        setupPeopleCount()
        
        addressLabel.setTitle("Cím: \(String(describing: restaurant.Address!))", for: .normal)
        
        globalContainer.ratingNetworkDelegate = self
        restaurant.galeryImageDelegate = self
        
        picker.delegate = self
        picker.dataSource = self
        
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .dateAndTime
        
        peopleTextField.inputView = picker
        dateTextField.inputView = datePicker
        
        peopleCountLabel.text = String(describing: reservation.selectedPeopleCount!)
        reservationDateLebel.text = reservation.date.toFullFormatString(withYear: false, withLongFormatMonth: true)
        
        datePicker.addTarget(self, action: #selector(reservationDateChanged), for: .valueChanged)
        sendRservation.addTarget(self, action: #selector(sendReservation(_:)), for: .touchUpInside)
        tapGestureRecognizer.addTarget(self, action: #selector(viewTapped(_:)))
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        scrollView.contentSize.height = contentView.bounds.height
        scrollView.contentSize.width = self.view.bounds.width
        scrollView.contentMode = .scaleToFill
        
        scrollView.addSubview(contentView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchRatings()
        restaurant?.getImages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupPeopleCount() {
        
        if let maxpeopleCount = restaurant?.MaxPeopleAtTable {
            
            for i in 1...maxpeopleCount {
                
                peopleCount.append(i)
            }
        }
    }

    private func fetchRatings() {
        
        globalContainer.fetchRatingsByRestaurantID(for: self.restaurant.ID!)
    }
    
    func viewTapped(_ sender: UITapGestureRecognizer) {
        
        resignTextFieldFirstResponder()
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
    
        resignTextFieldFirstResponder()
        
        switch sender.selectedSegmentIndex {
        case 0:
            contentView.bringSubview(toFront: reservationView)
        case 1:
            contentView.bringSubview(toFront: galeryCollectionView)
        case 2:
            contentView.bringSubview(toFront: ratingTableView)
        default:
            break
        }
        
        scrollView.contentOffset.y = 0
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
            message: "Foglalás részletei:\nAsztal \(reservation.selectedPeopleCount!) főre\nidőpont: \(reservation.date?.toFullFormatString(withYear: false, withLongFormatMonth: true) ?? "")\nhelyszín: \(restaurant.Name ?? "")",
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
        
        if let identifier = segue.identifier {
            
            if identifier == "showRestaurantOnMap" {
                
                if let destination = segue.destination as? MapViewController {
                    
                    destination.restaurants = [self.restaurant]
                }
            }
        }
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
        cell.detailTextLabel?.text = String(describing: ratings[indexPath.row].Value)
        
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

extension RestaurantViewController : UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return restaurant.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galeryCell", for: indexPath) as? GaleryCollectionViewCell {
            
            let width = collectionView.frame.width / 4
            
            cell.setFrame(x: indexPath.row, width: width)
            
            cell.imageView.image = restaurant.images[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension RestaurantViewController : RatingNetworkProtocol {
    
    func ratingRequestFinished(successed: Bool) {
        
        if successed {
            
            self.ratings = globalContainer.ratings[self.restaurant.ID!]!
        }
    }
}

extension RestaurantViewController : GaleryImageProtocol {
    
    func newImageAdded() {
        
        self.galeryCollectionView.reloadData()
    }
}

extension RestaurantViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let keyboardRectTopY = self.view.frame.height - keyboardSize.height
            
            let textFieldBottomY = dateTextField.frame.maxY + reservationView.frame.minY + (navigationController?.navigationBar.frame.height)!
            
            if textFieldBottomY > keyboardRectTopY {
                
                self.view.frame.origin.y = 0 - (textFieldBottomY - keyboardRectTopY)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = (navigationController?.navigationBar.frame.maxY)!
    }
}
