//
//  PredictiveTextScrollView.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-05.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation
import UIKIt

/**
 @a PredictiveTextScrollView is a subclass of @a UIScrollView designed to contain a number of @a UIButton subviews.
*/
class PredictiveTextScrollView: UIScrollView {
    
    // MARK: Constructors
    
    init(frame: CGRect) {
        super.init(frame: frame)
        self.canCancelContentTouches = true
        self.delaysContentTouches = false
    }
    
    // MARK: Overridden methods
    
    override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        return view is UIButton ? true : super.touchesShouldCancelInContentView(view)
    }
}