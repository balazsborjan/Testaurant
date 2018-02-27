//
//  CreateReservationTableViewCell.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2018. 02. 10..
//  Copyright © 2018. Kacsak. All rights reserved.
//

import UIKit
import TestaurantBL

class CreateReservationTableViewCell: UITableViewCell
{
    enum ReservationTableViewCellType
    {
        case Detail
        case Action
    }
    
    var type: ReservationTableViewCellType?
    {
        didSet
        {
            if type == .Detail
            {
                actionButton.isEnabled = false
                actionButton.isHidden = true
                textView.isHidden = false
            }
            else if type == .Action
            {
                textView.isHidden = true
                actionButton.isEnabled = true
                actionButton.isHidden = false
            }
        }
    }
    
    var peopleCount: Array<Int> = []
    
    let textView = UITextView()
    
    let actionButton: UIButton =
    {
        let button = UIButton()
        
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        button.setTitle("Foglalás elküldése", for: .normal)
        button.tintColor = UIColor.white
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        return button
    }()
    
    var delegate: NewReservationInformationDelegate?
    
    var keyboardView: ReservationKeyboardView =
    {
        var view = ReservationKeyboardView()
        
        if let window = UIApplication.shared.keyWindow
        {
            view = ReservationKeyboardView(frame: CGRect(x: 0, y: window.frame.height / 4 * 3, width: window.frame.width, height: window.frame.height / 4))
        }
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.textView.keyboardAppearance = UIKeyboardAppearance.dark
        
        self.addSubview(textView)
        self.addSubview(actionButton)
        
        setupTextView()
        setupActionButton()
        
        keyboardView.peopleCountPicker.delegate = self
        keyboardView.peopleCountPicker.dataSource = self
        keyboardView.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        keyboardView.doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        switch self.indexPath?.row
        {
            case 0?:
                self.keyboardView.usePeopleCountPicker()
            case 1?:
                self.keyboardView.useDatePicker()
            default:
                break
        }
    }
    
    private func setupTextView()
    {
        textView.delegate = self
        
        self.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        textLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        textLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        textLabel?.rightAnchor.constraint(equalTo: textView.leftAnchor, constant: 10).isActive = true
        
        textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
        
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .right
        textView.textColor = UIColor.white
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.keyboardAppearance = UIKeyboardAppearance.dark
        
        textView.inputView = keyboardView
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker)
    {
        self.textView.text = sender.date.toFullFormatString(withYear: true, withLongFormatMonth: false)
        self.delegate?.reservationDateChanged(newDate: sender.date)
    }
    
    @objc private func doneButtonPressed(_ sender: UIButton)
    {
        textView.resignFirstResponder()
    }
    
    private func setupActionButton()
    {
        actionButton.frame = self.frame
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        actionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 15).isActive = true
        actionButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateReservationTableViewCell : UITextViewDelegate
{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        switch self.indexPath?.row
        {
            case 0?:
                keyboardView.usePeopleCountPicker()
            case 1?:
                keyboardView.useDatePicker()
            default:
                break
        }
        
        return true
    }
}

extension CreateReservationTableViewCell : UIPickerViewDataSource, UIPickerViewDelegate
{
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
        self.textView.text = String(describing: peopleCount[row])
        self.delegate?.reservationPeopleCountChanged(newPeopleCount: peopleCount[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let titleData = String(describing: peopleCount[row])
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.white])
        
        return myTitle
    }
}












