//
//  SwipeView.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-18.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation
import UIKit

/**
    A subclass of UIView that takes points and draws them to the screen.
*/
class SwipeView: UIView {
    
    // MARK: Constants
    
    private let maxLength = CGFloat(300.0)
    
    // MARK: Properties
    
    private lazy var points = [CGPoint]()
    
    private var swipeLength: CGFloat {
        get {
            if (points.count < 2) {
                return 0
            }
            var total = CGFloat(0.0)
            var currentPoint: CGPoint!
            var previousPoint: CGPoint!
            for i in 2..<points.count {
                currentPoint = points[i]
                previousPoint = points[i - 1]
                total += currentPoint.distance(previousPoint)
            }
            return total
        }
    }
    
    // MARK: Constructors
    
    init(containerView: UIView, topOffset: CGFloat) {
        super.init(frame: CGRectMake(0.0, topOffset, containerView.frame.width, containerView.frame.height - topOffset))
        opaque = false
        backgroundColor = UIColor.clearColor()
        userInteractionEnabled = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overridden methods
    
    override func drawRect(rect: CGRect) {
        if points.count >= 3 {
            let context = UIGraphicsGetCurrentContext()
            
            for i in 2..<points.count {
                // Interpolate gradient and calculate line width.
                let percentage = CGFloat(i) / CGFloat(points.count)
                CGContextSetRGBStrokeColor(context, (41.0 + (67.0 - 41.0) * percentage)/255, (10.0 + (116.0 - 10.0) * percentage)/255, (199.0 + (224.0 - 199.0) * percentage)/255, 1.0)
                CGContextSetLineWidth(context, pow(percentage, 0.5) * 4.0)

                // Three points needed for quadratic bezier smoothing.
                let currentPoint = points[i]
                let previousPoint1 = points[i - 1]
                let previousPoint2 = points[i - 2]
                
                // Calculate midpoints used in quadratic bezier smoothing.
                let midPoint1 = previousPoint1.midPoint(previousPoint2)
                let midPoint2 = currentPoint.midPoint(previousPoint1)
            
                // Draw bezier.
                CGContextMoveToPoint(context, midPoint1.x, midPoint1.y)
                CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, midPoint2.x, midPoint2.y)
                CGContextStrokePath(context)
            }
        }
    }
    
    // MARK: Overridden methods
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        drawTouch(touches.first as? UITouch)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        drawTouch(touches.first as? UITouch)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        clear()
    }

    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        clear()
    }

    // MARK: Helper methods
    
    private func clear() {
        points.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    private func drawTouch(touch: UITouch?) {
        if let touch = touch {
            let touchPoint = touch.locationInView(self)
            let point = CGPointMake(touchPoint.x, touchPoint.y)
            points.append(point)
            while swipeLength > maxLength {
                points.removeAtIndex(0)
            }
            setNeedsDisplay()
        }
    }
}