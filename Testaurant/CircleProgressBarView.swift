//
//  NetworkProgressBarView.swift
//  Testaurant
//
//  Created by Balázs Bojrán on 2018. 02. 12..
//  Copyright © 2018. Kacsak. All rights reserved.
//

import UIKit

var progressBar: CircleProgressBarView?

extension UIApplication
{
    func showProgressBar()
    {
        if self.keyWindow != nil
        {
            if progressBar == nil
            {
                progressBar = CircleProgressBarView(frame: self.keyWindow!.frame)
                self.keyWindow!.addSubview(progressBar!)
            }
            
            self.keyWindow!.bringSubview(toFront: progressBar!)
        }
    }
    
    func hideProgressBar()
    {
        if self.keyWindow != nil
        {
            if progressBar != nil
            {
                self.keyWindow!.sendSubview(toBack: progressBar!)
            }
        }
    }
}

class CircleProgressBarView: UIView
{
    let shapeLayer = CAShapeLayer()
    let pulsationLayer = CAShapeLayer()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupBackgroundView()
        setupProgressBarLayers()
    }
    
    init()
    {
        let window = UIApplication.shared.keyWindow!
        
        super.init(frame: CGRect(x: 0, y: 0, width: window.frame.width / 2, height: window.frame.width / 2))
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        
        setupBackgroundView()
        setupProgressBarLayers()
        
        window.addSubview(self)
        self.center = window.center
    }
    
    private func setupBackgroundView()
    {
        let effect = UIBlurEffect(style: .dark)
        let vev = UIVisualEffectView(frame: self.frame)
        vev.effect = effect

        self.addSubview(vev)
    }
    
    private func setupProgressBarLayers()
    {
        let center = self.center
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 50, startAngle: -(CGFloat.pi / 2), endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsationLayer.path = circularPath.cgPath
        pulsationLayer.strokeColor = UIColor.green.withAlphaComponent(0.5).cgColor
        pulsationLayer.fillColor = UIColor.clear.cgColor
        pulsationLayer.lineWidth = 10
        pulsationLayer.lineCap = kCALineCapRound // Rounded lineend
        pulsationLayer.frame = self.frame
        pulsationLayer.position = self.center
        self.layer.addSublayer(pulsationLayer)
        
        startPulsing()
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.lineCap = kCALineCapRound // Rounded lineend
        shapeLayer.strokeEnd = 1
        self.layer.addSublayer(shapeLayer)
        
        let loadingLabel = UILabel(frame: CGRect(
            origin: self.frame.origin,
            size: CGSize(width: self.frame.width / 2, height: self.frame.width / 2)))

        loadingLabel.center = self.center
        loadingLabel.text = "Betöltés"
        loadingLabel.textColor = UIColor.white
        loadingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        loadingLabel.adjustsFontSizeToFitWidth = true
        loadingLabel.textAlignment = .center

        self.addSubview(loadingLabel)
    }
    
    func startPulsing()
    {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.2
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsationLayer.add(animation, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
