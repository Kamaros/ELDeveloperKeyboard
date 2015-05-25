//
//  SuggestionButton.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-04.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation
import UIKit

/**
    The method declared in the SuggestionButtonDelegate protocol allow the adopting delegate to respond to messages from the SuggestionButton class, handling button presses.
*/
protocol SuggestionButtonDelegate: class {
    /**
        Respond to the SuggestionButton being pressed.
    
        :param: button The SuggestionButton that was pressed.
    */
    func handlePressForSuggestionButton(button: SuggestionButton)
}

class SuggestionButton: UIButton {
    
    // MARK: Properties
    
    weak var delegate: SuggestionButtonDelegate?
    
    var title: String {
        didSet {
            setTitle(title, forState: .Normal)
        }
    }
    
    // MARK: Constructors
    
    init(frame: CGRect, title: String, delegate: SuggestionButtonDelegate?) {
        self.title = title
        self.delegate = delegate
        
        super.init(frame: frame)
        
        setTitle(title, forState: .Normal)
        titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)
        titleLabel?.textAlignment = .Center
        setTitleColor(UIColor(white: 238.0/255, alpha: 1), forState: .Normal)
        setTitleColor(UIColor(red: 119.0/255, green: 198.0/255, blue: 237.0/255, alpha: 1.0), forState: .Highlighted)
        titleLabel?.sizeToFit()
        addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Event handlers
    
    func buttonPressed(button: SuggestionButton) {
        delegate?.handlePressForSuggestionButton(self)
    }
}