//
//  CGPointMidpoint.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-19.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    /**
        Calculates the midpoint between two CGPoints.
    
        :returns: The CGPoint at the midpoint of two CGPoints.
    */
    func midPoint(point: CGPoint) -> CGPoint {
        return CGPointMake((x + point.x) / 2.0, (y + point.y) / 2.0)
    }
    
    /**
        Calculates the distance between two CGPoints.
        :returns: The distance between two CGPoints.
    */
    func distance(point: CGPoint) -> CGFloat {
        var dx = x - point.x
        var dy = y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}