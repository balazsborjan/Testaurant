//
//  ProbaViewController.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2018. 02. 21..
//  Copyright © 2018. Kacsak. All rights reserved.
//

import UIKit
import TestaurantBL

class ProbaViewController: UIViewController, UIScrollViewDelegate
{
    var restaurant: RestaurantDto!
    
    @IBOutlet weak var openingHoursView: UIView!
    @IBOutlet weak var createReservationCardView: CreateReservationCardView!
    
    
    @IBOutlet weak var titleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var titleViewYPos = self.titleView.frame.maxY
    
    @IBOutlet weak var closeViewControllerButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 3000)
        
        setupTitleView()
        setupCardViews()
        
        closeViewControllerButton.addTarget(self, action: #selector(closeViewController(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.backgroundColor = UIColor.clear
    }
    
    @objc private func closeViewController(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func generatePeopleCountArrayFromRestaurant() -> Array<Int>
    {
        var resultArray = Array<Int>()
        
        if self.restaurant.MaxPeopleAtTable > 0
        {
            for i in 1..<(self.restaurant.MaxPeopleAtTable + 1)
            {
                resultArray.append(i)
            }
        }
        else
        {
            for i in 1..<(self.restaurant.MaxPeopleCount + 1)
            {
                resultArray.append(i)
            }
        }
        
        return resultArray
    }
    
    private func setupTitleView()
    {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.image = restaurant.MainImage.image
        titleImageView.contentMode = .scaleAspectFill
        titleImageView.clipsToBounds = true
        titleImageView.layer.cornerRadius = titleImageView.frame.width / 2
        titleLabel.text = restaurant.Name
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupCardViews()
    {
        self.scrollView.addSubview(createReservationCardView)
        self.scrollView.addSubview(openingHoursView)
        
        createReservationCardView.peopleCount = generatePeopleCountArrayFromRestaurant()
        createReservationCardView.translatesAutoresizingMaskIntoConstraints = false
        createReservationCardView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        createReservationCardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        createReservationCardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        
        openingHoursView.translatesAutoresizingMaskIntoConstraints = false
        openingHoursView.topAnchor.constraint(equalTo: createReservationCardView.bottomAnchor, constant: 10).isActive = true
        openingHoursView.leftAnchor.constraint(equalTo: createReservationCardView.leftAnchor, constant: 0).isActive = true
        openingHoursView.rightAnchor.constraint(equalTo: createReservationCardView.rightAnchor, constant: 0).isActive = true
        openingHoursView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let yPos = 200 - scrollView.contentOffset.y - 20
        let titleViewHeight = max(80, yPos)
        
        titleViewHeightConstraint.constant = titleViewHeight
        self.view.layoutIfNeeded()
        titleImageView.layer.cornerRadius = titleImageView.frame.width / 2
    }
}












