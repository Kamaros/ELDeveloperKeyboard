//
//  KeyButton.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

/**
    KeyButton is a UIButton subclass with keyboard button styling.
*/
class KeyButton: UIButton {
    
    // MARK: Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)
        self.titleLabel?.textAlignment = .Center
        self.setTitleColor(UIColor(white: 238.0/255, alpha: 1.0), forState: UIControlState.Normal)
        self.titleLabel?.sizeToFit()
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let gradientColors: [AnyObject] = [UIColor(red: 80.0/255, green: 80.0/255, blue: 80.0/255, alpha: 1.0).CGColor, UIColor(red: 60.0/255, green: 60.0/255, blue: 60.0/255, alpha: 1.0).CGColor]
        gradient.colors = gradientColors // Declaration broken into two lines to prevent 'unable to bridge to Objective C' error.
        self.setBackgroundImage(gradient.UIImageFromCALayer(), forState: .Normal)
        
        let selectedGradient = CAGradientLayer()
        selectedGradient.frame = self.bounds
        let selectedGradientColors: [AnyObject] = [UIColor(red: 67.0/255, green: 116.0/255, blue: 224.0/255, alpha: 1.0).CGColor, UIColor(red: 32.0/255, green: 90.0/255, blue: 214.0/255, alpha: 1.0).CGColor]
        selectedGradient.colors = selectedGradientColors // Declaration broken into two lines to prevent 'unable to bridge to Objective C' error.
        self.setBackgroundImage(selectedGradient.UIImageFromCALayer(), forState: .Selected)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3.0
        
        self.contentVerticalAlignment = .Center
        self.contentHorizontalAlignment = .Center
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}