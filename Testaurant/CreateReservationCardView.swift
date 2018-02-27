//
//  CreateReservationCardView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2018. 02. 21..
//  Copyright © 2018. Kacsak. All rights reserved.
//

import UIKit

class CreateReservationCardView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    lazy var sendReservationButton: UIButton =
    {
        return self.getReservationControl(in: self, with: "reservationButton") as! UIButton
    }()
    
    lazy var reservationPeopleCountTextField: UITextField =
    {
        return self.getReservationControl(in: self, with: "peopleCountTextField") as! UITextField
    }()
    
    lazy var reservationDateTextField: UITextField =
    {
        return self.getReservationControl(in: self, with: "dateTextField") as! UITextField
    }()
    
    var keyboardView: ReservationKeyboardView =
    {
        var view = ReservationKeyboardView()
        
        if let window = UIApplication.shared.keyWindow
        {
            view = ReservationKeyboardView(frame: CGRect(x: 0, y: window.frame.height / 4 * 3, width: window.frame.width, height: window.frame.height / 4))
        }
        
        return view
    }()
    
    var peopleCount: Array<Int> = []
    
    var delegate: NewReservationInformationDelegate?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 12.0
        
        setCornerRadius(view: self)
        
        keyboardView.peopleCountPicker.delegate = self
        keyboardView.peopleCountPicker.dataSource = self
        keyboardView.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        keyboardView.doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        reservationDateTextField.delegate = self
        reservationDateTextField.keyboardAppearance = UIKeyboardAppearance.dark
        reservationDateTextField.inputView = keyboardView
        
        reservationPeopleCountTextField.delegate = self
        reservationPeopleCountTextField.keyboardAppearance = UIKeyboardAppearance.dark
        reservationPeopleCountTextField.inputView = keyboardView
    }
    
    private func setCornerRadius(view: UIView)
    {
        for v in view.subviews
        {
            v.clipsToBounds = true
            v.layer.cornerRadius = 12.0
            
            setCornerRadius(view: v)
        }
    }
    
    private func getReservationControl(in view: UIView, with restorationId: String) -> UIView?
    {
        var result: UIView?
        
        for v in view.subviews
        {
            if result == nil
            {
                if v.restorationIdentifier == restorationId
                {
                    result = v
                }
                else
                {
                    result = getReservationControl(in: v, with: restorationId)
                }
            }
        }
        
        return result
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker)
    {
        self.reservationDateTextField.text = sender.date.toFullFormatString(withYear: true, withLongFormatMonth: false)
        self.delegate?.reservationDateChanged(newDate: sender.date)
    }
    
    @objc private func doneButtonPressed(_ sender: UIButton)
    {
        reservationPeopleCountTextField.resignFirstResponder()
        reservationDateTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return peopleCount.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.reservationPeopleCountTextField.text = String(describing: peopleCount[row])
        self.delegate?.reservationPeopleCountChanged(newPeopleCount: peopleCount[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let titleData = String(describing: peopleCount[row])
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.white])
        
        return myTitle
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.reservationPeopleCountTextField
        {
            self.keyboardView.usePeopleCountPicker()
        }
        else
        {
            self.keyboardView.useDatePicker()
        }
        
        return true
    }
}

protocol NewReservationInformationDelegate
{
    func reservationDateChanged(newDate: Date!) -> Void
    
    func reservationPeopleCountChanged(newPeopleCount: Int) -> Void
}









