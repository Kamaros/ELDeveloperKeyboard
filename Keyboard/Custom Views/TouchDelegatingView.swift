//
//  TouchForwardingView.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-08-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation
import UIKit

/**
 The methods declared in the @a TouchForwardingViewDelegate protocol allow the adopting delegate to respond to override the behaviour of @a hitTest:withEvent: for the @a TouchForwardingView class.
*/
protocol TouchForwardingViewDelegate: class {
    
    /**
     Allows the delegate to override the behaviour of @a hitTest:withEvent: for this view.
     @param point 
            The @a CGPoint that was touched.
     @param event 
            The touch event.
     @param superResult 
            The @a UIView returned by the call to @a super.
     @return A @a UIView that the delegate decides should receive the touch event.
    */
    func viewForHitTestWithPoint(point: CGPoint, event: UIEvent?, superResult: UIView?) -> UIView?
}

class TouchForwardingView: UIView {
    
    // MARK: Properties
    
    weak var delegate: TouchForwardingViewDelegate?
    
    // MARK: Constructors
    
    init(frame: CGRect, delegate: TouchForwardingViewDelegate?) {
        self.delegate = delegate
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // MARK: Overridden methods
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, withEvent: event)
        if let unwrappedDelegate = delegate {
            return unwrappedDelegate.viewForHitTestWithPoint(point, event: event, superResult: result)
        }
        return result
    }
}