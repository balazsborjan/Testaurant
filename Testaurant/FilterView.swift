//
//  FilterView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2017. 06. 20..
//  Copyright © 2017. Kacsak. All rights reserved.
//

import UIKit

class FilterView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    
    let didChangeStateEvent = Event<Bool>()
    
    private var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let screenBounds = UIScreen.main.bounds
        let width = UIScreen.main.bounds.width / 5 * 4
        
        self.frame = CGRect(origin: CGPoint(x: screenBounds.maxX, y: screenBounds.minY), size: CGSize(width: width, height: screenBounds.height))
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeOnSwipe(_:)))
        swipeGestureRecognizer?.direction = .right
        
        self.addGestureRecognizer(swipeGestureRecognizer!)
    }
    
    func setFilterTableViewFrame(toNavBarRect rect: CGRect) {
        
        self.headerView.frame = rect
    }
    
    // MARK: Show/Hide view
    
    func show() {
        
        self.superview?.bringSubview(toFront: self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width / 5
        })
        
        didChangeStateEvent.raise(data: false)
    }
    
    func hide(completion: ((Bool) -> Void)?) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = UIScreen.main.bounds.maxX
        }, completion: completion)
        
        didChangeStateEvent.raise(data: true)
    }
    
    @objc private func closeOnSwipe(_ sender: UISwipeGestureRecognizer) {
        
        self.hide(completion: nil)
    }
}
