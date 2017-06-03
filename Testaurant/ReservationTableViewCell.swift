//
//  ReservationTableViewCell.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 05. 31..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class ReservationPeopleTableViewCell: UITableViewCell {
    
    let picker = UIPickerView()
    
    var peopleCount: [Int] = []
    
    var restaurant: Restaurant? {
        didSet{
            if restaurant != nil {
                self.setupPeopleCount()
            }
        }
    }
    
    var reservation: Reservation?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picker.dataSource = self
        picker.delegate = self
        
        textField.inputView = picker
        textField.delegate = self
        
        infoLabel.text = "Személyek száma"
        detailLabel.text = "1"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setupPeopleCount() {
        
        for i in 1...restaurant!.MaxPeopleAtTable! {
            
            peopleCount.append(i)
        }
    }
}

class ReservationDateTableViewCell: UITableViewCell {
    
    let picker = UIDatePicker()
    
    var reservation: Reservation?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picker.addTarget(self, action: #selector(reservationDateChanged(_:)), for: .valueChanged)
        picker.minimumDate = Date()
        picker.minuteInterval = 30
        
        textField.inputView = picker
        textField.delegate = self
        
        infoLabel.text = "Foglalás időpontja"
        detailLabel.text = Date().toFullFormatString(withYear: false, withLongFormatMonth: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc private func reservationDateChanged(_ sender: UIDatePicker) {
        
        reservation?.date = sender.date
        self.detailLabel.text = sender.date.toFullFormatString(withYear: false, withLongFormatMonth: true)
    }
}

extension ReservationPeopleTableViewCell : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return peopleCount.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        reservation?.selectedPeopleCount = peopleCount[row]
        self.detailLabel.text = String(describing: (row + 1))
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(describing: peopleCount[row])
    }
}

extension ReservationPeopleTableViewCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.detailLabel.textColor = self.tintColor
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.detailLabel.textColor = UIColor.black
    }
}

extension ReservationDateTableViewCell : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.detailLabel.textColor = self.tintColor
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.detailLabel.textColor = UIColor.black
    }
}












