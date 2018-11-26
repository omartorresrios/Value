//
//  Extensions.swift
//  Value
//
//  Created by Omar Torres on 11/2/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import UIKit

// Callbacks
// Typealias for callbacks used
typealias Callback = (_ success: Bool) -> ()

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainBlue() -> UIColor {
        return UIColor.rgb(red: 29, green: 161, blue: 242)
    }
    
    static func mainGreen() -> UIColor {
        return UIColor.rgb(red: 104, green: 237, blue: 198)
    }
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func clearSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview();
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

extension UIButton
    
{
    func setUpLayer(sampleButton: UIButton?) {
        sampleButton!.setTitle("GET STARTED", for: UIControlState.normal)
        sampleButton?.tintColor =  UIColor.white
        sampleButton!.frame = CGRect(x:50, y:500, width:170, height:40)
        sampleButton!.layer.borderWidth = 1.0
        sampleButton!.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        sampleButton!.layer.cornerRadius = 5.0
        
        sampleButton!.layer.shadowRadius =  3.0
        sampleButton!.layer.shadowColor =  UIColor.white.cgColor
        sampleButton!.layer.shadowOpacity =  0.3
    }
    
}
