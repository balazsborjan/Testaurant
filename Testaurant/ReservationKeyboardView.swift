//
//  ReservationKeyboardView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2018. 02. 11..
//  Copyright © 2018. Kacsak. All rights reserved.
//

import Foundation

class ReservationKeyboardView: UIView
{
    let doneSectorHeight: CGFloat = 40.0
    
    var doneButton = UIButton()
    
    lazy var doneSectorView: UIView =
    {
        let view: UIView!
        
        if let window = UIApplication.shared.keyWindow
        {
            view = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: doneSectorHeight))
            
            doneButton = UIButton(frame: CGRect(x: view.frame.width / 4 * 3, y: 0, width: view.frame.width / 4, height: view.frame.height))
            doneButton.setTitle("Kész", for: .normal)
            doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            
            view.addSubview(doneButton)
            
            let topBorderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
            topBorderView.backgroundColor = UIColor.white
            
            view.addSubview(topBorderView)
            
            return view
        }
        
        return UIView()
    }()
    
    let peopleCountPicker = UIPickerView()
    
    let datePicker = UIDatePicker()
    
    override init(frame: CGRect)
    {
        let newFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: peopleCountPicker.bounds.height + doneSectorHeight)
        
        super.init(frame: newFrame)
        
        self.addSubview(doneSectorView)
        self.addSubview(peopleCountPicker)
        self.addSubview(datePicker)
        
        setupDatePicker()
        setupPeopleCountPicker()
    }
    
    private func setupDatePicker()
    {
        datePicker.frame = CGRect(x: 0, y: doneSectorHeight, width: self.frame.width, height: self.frame.height - doneSectorHeight)
        datePicker.date = Date()
        datePicker.minimumDate = Date()
        datePicker.locale = Locale.init(identifier: "HU")
        datePicker.setValue(false, forKeyPath: "highlightsToday")
    }
    
    private func setupPeopleCountPicker()
    {
        peopleCountPicker.frame = CGRect(x: 0, y: doneSectorHeight, width: self.frame.width, height: self.frame.height - doneSectorHeight)
    }
    
    func useDatePicker()
    {
        self.sendSubview(toBack: peopleCountPicker)
        self.bringSubview(toFront: datePicker)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.peopleCountPicker.frame.origin.y = UIApplication.shared.keyWindow!.frame.maxY
        }) { (true) in
            self.datePicker.frame.origin.y = self.doneSectorView.frame.maxY
        }
    }
    
    func usePeopleCountPicker()
    {
        self.sendSubview(toBack: datePicker)
        self.bringSubview(toFront: peopleCountPicker)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.datePicker.frame.origin.y = UIApplication.shared.keyWindow!.frame.maxY
        }) { (true) in
            self.peopleCountPicker.frame.origin.y = self.doneSectorView.frame.maxY
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clear
        
        doneSectorView.backgroundColor = UIColor.clear
        doneButton.backgroundColor = UIColor.clear
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.backgroundColor = UIColor.clear
        datePicker.inputView?.backgroundColor = UIColor.clear
        peopleCountPicker.backgroundColor = UIColor.clear
        peopleCountPicker.inputView?.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
