//
//  RestaurantViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 31..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit
import MapKit
import TestaurantBL

class RestaurantViewController: UIViewController
{
    var restaurant: RestaurantDto!
    var reservation: ReservationDto!
    var peopleCount: [Int] = []
    
    var ratings: [RatingDto] = []
    {
        didSet
        {
            self.ratingTableView.reloadData()
        }
    }
    
    var sendReservationResult = false
    {
        didSet
        {
            if sendReservationResult == false
            {
                self.showReservationFailAlert()
            }
        }
    }
    
    @IBOutlet weak var fullContentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var contentViewContainer: UIView!
    
    @IBOutlet weak var openingTimeLabel: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet var contentView: SelectedRestaurantContentView!
    
    @IBOutlet var galeryCollectionView: UICollectionView!
    
    @IBOutlet var ratingTableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var peopleCountLabel: UILabel!
    
    @IBOutlet weak var peopleTextField: UITextField!
    
    @IBOutlet weak var reservationDateLebel: UILabel!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet var keyboardView: UIView!
    
    @IBOutlet weak var keyboardPicker: UIPickerView!
    
    @IBOutlet weak var keyboardDatePicker: UIDatePicker!
    
    @IBOutlet weak var sendRservation: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet var mapTapGestureRecognizer: UITapGestureRecognizer!
    
    var pickerTapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupPeopleCount()
        fetchRatings()
        setupImageView()
        setupContentView()
        setupMapView()
        
        reservation = ReservationDto(restaurant: self.restaurant)
        
        addressLabel.text = "Cím: \(String(describing: restaurant.Address!))"
        peopleCountLabel.text = String(describing: reservation.SelectedPeopleCount!)
        reservationDateLebel.text = reservation.ReservationDate.toFullFormatString(withYear: false, withLongFormatMonth: true)
        
        keyboardDatePicker.minimumDate = Date()
        keyboardDatePicker.addTarget(self, action: #selector(reservationDateChanged(_:)), for: .valueChanged)
        
        peopleTextField.inputView = keyboardView
        dateTextField.inputView = keyboardView
        
        sendRservation.addTarget(self, action: #selector(sendReservation(_:)), for: .touchUpInside)
        tapGestureRecognizer.addTarget(self, action: #selector(viewTapped(_:)))
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "\(restaurant.Name!)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setupPeopleCount()
    {
        if let maxpeopleCount = restaurant?.MaxPeopleAtTable
        {
            for i in 1...maxpeopleCount
            {
                peopleCount.append(i)
            }
        }
    }
    
    private func setupImageView()
    {
        imageView.image = restaurant.MainImage.image
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
    }
    
    private func setupContentView()
    {
        let y = segmentControl.frame.maxY + 5
        let height = self.view.frame.maxY - fullContentView.frame.minY - y
        
        contentView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
        
        scrollView.contentSize.height = 5000
        
        fullContentView.addSubview(contentView)
    }
    
    private func setupMapView()
    {
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 10.0
        mapView.layer.borderColor = UIColor.darkGray.cgColor
        mapView.layer.borderWidth = 0.2
        
        mapView.addAnnotation(restaurant)
        
        var zoomRect: MKMapRect = MKMapRectNull
        
        let annotationPoint: MKMapPoint = MKMapPointForCoordinate(restaurant.coordinate)
        
        let pointRect: MKMapRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 3000, 3000)
        
        if MKMapRectIsNull(zoomRect)
        {
            zoomRect = pointRect
        }
        else
        {
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
        }
        
        mapView.setVisibleMapRect(zoomRect, animated: true)
        mapView.setCenter(restaurant.coordinate, animated: false)
        
        mapTapGestureRecognizer.addTarget(self, action: #selector(showRestaurantOnMap(_:)))
        mapView.addGestureRecognizer(mapTapGestureRecognizer)
    }

    private func fetchRatings()
    {
        _ = DBService.Instance.GetRatingsBy(restaurant: self.restaurant)
    }
    
    @objc private func viewTapped(_ sender: Any?)
    {
        resignTextFieldFirstResponder()
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl)
    {
        resignTextFieldFirstResponder()
        
        switch sender.selectedSegmentIndex
        {
            case 0:
                contentView.bringSubview(toFront: scrollView)
            case 1:
                contentView.bringSubview(toFront: galeryCollectionView)
            case 2:
                contentView.bringSubview(toFront: ratingTableView)
            default:
                break
        }
    }
    
    @IBAction func hideKeyboard(_ sender: UIButton)
    {
        self.viewTapped(sender)
    }
    
    
    @objc private func reservationDateChanged(_ sender: UIDatePicker)
    {
        reservation.ReservationDate = sender.date
        self.reservationDateLebel.text = sender.date.toFullFormatString(withYear: false, withLongFormatMonth: true)
    }
    
    @objc fileprivate func resignTextFieldFirstResponder()
    {
        peopleTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
    }
    
    fileprivate func addTargetToSendReservationButton(button: UIButton)
    {
        button.addTarget(self, action: #selector(sendReservation), for: .touchUpInside)
    }
    
    @objc private func sendReservation(_ sender: UIButton)
    {
        let alert = UIAlertController(
            title: "Foglalás küldése",
            message: "Foglalás részletei:\nAsztal \(reservation.SelectedPeopleCount!) főre\nidőpont: \(reservation.ReservationDate.toFullFormatString(withYear: false, withLongFormatMonth: true) )\nhelyszín: \(restaurant.Name ?? "")",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Küldés", style: .default, handler: { (action) in
            
//            self.sendReservationResult = DBService.Instance.Send(reservation: self.reservation)
        }))
        
        alert.addAction(UIAlertAction(title: "Mégsem", style: .destructive, handler: { (action) in
            
            //DO NOTHING
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showReservationFailAlert()
    {
        let alert = UIAlertController(
            title: "Sikertelen foglalás",
            message: "A foglalás sikertelen volt, kérjük próbálkozzon újra",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Rendben", style: .default, handler: { (action) in
            
           //DO NOTHING
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func reservationSent() -> Void
    {
        showReservationStatusAlert()
    }
    
    private func showReservationStatusAlert()
    {
        let alert = UIAlertController(
            title: "Foglalás elküldve",
            message: "A foglalás sikeresen feldolgozásra került\nKöszönjük",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Rendben", style: .default, handler: { (action) in
            
            //DO NOTHING
        }))
        
        alert.addAction(UIAlertAction(title: "Megtekintem", style: .destructive, handler: { (action) in
            
            self.showReservation()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showReservation()
    {
        self.performSegue(withIdentifier: "showNewReservation", sender: self)
    }
    
    @objc private func showRestaurantOnMap(_ sender: UITapGestureRecognizer)
    {
        if sender.view == mapView
        {
            self.performSegue(withIdentifier: "showRestaurantOnMap", sender: mapView)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        resignTextFieldFirstResponder()
        
        self.navigationItem.title = ""
        
        if let identifier = segue.identifier
        {
            if identifier == "showRestaurantOnMap"
            {
                if let destination = segue.destination as? MapViewController
                {
                    destination.restaurants = [self.restaurant]
                }
            }
        }
    }
}

extension RestaurantViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as? RatingTableViewCell
        {
            let rating = ratings[indexPath.row]
            
            cell.nameLabel.text = rating.UserName
            cell.ratingTextLabel.text = rating.Text
            cell.ratingValueLabel.text = String(describing: rating.Value)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension RestaurantViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(self.peopleTextField) {
            
            textField.inputView?.sendSubview(toBack: keyboardDatePicker)
            textField.inputView?.bringSubview(toFront: keyboardPicker)
            
            self.peopleCountLabel.textColor = textField.tintColor
            
        } else if textField.isEqual(self.dateTextField) {
            
            textField.inputView?.sendSubview(toBack: keyboardPicker)
            textField.inputView?.bringSubview(toFront: keyboardDatePicker)
            
            self.reservationDateLebel.textColor = textField.tintColor
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
        
        reservation.SelectedPeopleCount = peopleCount[row]
        self.peopleCountLabel.text = String(describing: (row + 1))
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(describing: peopleCount[row])
    }
}

extension RestaurantViewController : UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return restaurant.GalleryImages.count / 4 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if ((section + 1) * 4) > restaurant.GalleryImages.count
        {
            return restaurant.GalleryImages.count - (section * 4)
        }
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galeryCell", for: indexPath) as? GaleryCollectionViewCell
        {
            let width = collectionView.frame.width / 4
            
            cell.setFrame(at: indexPath, width: width)
            
            cell.imageView.image = UIImage(data: self.restaurant.GalleryImages[indexPath.row].Image)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension RestaurantViewController : FBUserInfoDelegate
{
    func didGetUserInfo(successed: Bool)
    {
        if successed
        {
            self.ratingTableView.reloadData()
        }
    }
}

extension RestaurantViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView])
    {
        for view in views
        {
            view.canShowCallout = false
        }
    }
}

extension RestaurantViewController : UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

extension RestaurantViewController
{
    @objc func keyboardWillShow(notification: NSNotification)
    {
        scrollView.contentOffset.y = 0
        
        let keyboardRectTopY = self.view.frame.height - keyboardView.frame.height
        
        let reservationButtonBottomY = self.fullContentView.frame.minY + sendRservation.frame.maxY + contentView.frame.minY
        
        if reservationButtonBottomY > keyboardRectTopY
        {
            self.fullContentView.frame.origin.y = navigationController!.navigationBar.frame.maxY - segmentControl.frame.minY + 3
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        self.fullContentView.frame.origin.y = navigationController!.navigationBar.frame.maxY
    }
}






