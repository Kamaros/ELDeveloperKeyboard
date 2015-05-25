//
//  UIImageFromCALayer.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension CALayer {
    /**
        Creates a UIImage from a CALayer.
     
        :returns: A UIImage that appears identical to the CALayer.
    */
    func UIImageFromCALayer() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 0)
        renderInContext(UIGraphicsGetCurrentContext())
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
}