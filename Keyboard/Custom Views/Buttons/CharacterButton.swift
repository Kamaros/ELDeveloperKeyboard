//
//  CharacterButton.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation
import UIKit

/**
 The methods declared in the @a CharacterButtonDelegate protocol allow the adopting delegate to respond to messages from the @a CharacterButton class, handling button presses and swipes.
*/
protocol CharacterButtonDelegate {
    /**
     Respond to the @a CharacterButton being pressed.
     @param button 
            The @a CharacterButton that was pressed.
    */
    func handlePressForButton(button: CharacterButton)
    
    /**
     Respond to the @a CharacterButton being up-swiped.
     @param button
            The @a CharacterButton that was up-swiped.
    */
    func handleSwipeUpForButton(button: CharacterButton)
    
    /**
     Respond to the @a CharacterButton being down-swiped.
     @param button
            The @a CharacterButton that was down-swiped.
    */
    func handleSwipeDownForButton(button: CharacterButton)
}

/**
 @a CharacterButton is a @a KeyButton subclass associated with three characters (primary, secondary, and tertiary) as well as three gestures (press, swipe up, and swipe down).
*/
class CharacterButton: KeyButton {
    
    // MARK: Properties
    
    var delegate: CharacterButtonDelegate?
    
    var primaryCharacter: String {
        didSet {
            if primaryLabel {
                primaryLabel.text = primaryCharacter
            }
        }
    }
    var secondaryCharacter: String {
        didSet {
            if secondaryLabel {
                secondaryLabel.text = secondaryCharacter
            }
        }
    }
    var tertiaryCharacter: String {
        didSet {
            if tertiaryLabel {
                tertiaryLabel.text = tertiaryCharacter
            }
        }
    }
    
    private(set) var primaryLabel: UILabel!
    private(set) var secondaryLabel: UILabel!
    private(set) var tertiaryLabel: UILabel!
    
    // MARK: Constructors
    
    init(frame: CGRect, primaryCharacter: String, secondaryCharacter: String, tertiaryCharacter: String, delegate: CharacterButtonDelegate?) {
        
        self.primaryCharacter = primaryCharacter
        self.secondaryCharacter = secondaryCharacter
        self.tertiaryCharacter = tertiaryCharacter
        self.delegate = delegate
        
        super.init(frame: frame)
        
        self.primaryLabel = UILabel(frame: CGRectMake(frame.width * 0.2, 0.0, frame.width * 0.8, frame.height * 0.95))
        self.primaryLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        self.primaryLabel.textColor = UIColor(white: 238.0/255, alpha: 1.0)
        self.primaryLabel.textAlignment = .Left
        self.primaryLabel.text = primaryCharacter
        self.addSubview(self.primaryLabel)
        
        self.secondaryLabel = UILabel(frame: CGRectMake(0.0, 0.0, frame.width * 0.9, frame.height * 0.3))
        self.secondaryLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        self.secondaryLabel.adjustsFontSizeToFitWidth = true
        self.secondaryLabel.textColor = UIColor(white: 187.0/255, alpha: 1.0)
        self.secondaryLabel.textAlignment = .Right
        self.secondaryLabel.text = secondaryCharacter
        self.addSubview(self.secondaryLabel)
        
        self.tertiaryLabel = UILabel(frame: CGRectMake(0.0, frame.height * 0.65, frame.width * 0.9, frame.height * 0.25))
        self.tertiaryLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        self.tertiaryLabel.textColor = UIColor(white: 187.0/255, alpha: 1.0)
        self.tertiaryLabel.adjustsFontSizeToFitWidth = true
        self.tertiaryLabel.textAlignment = .Right
        self.tertiaryLabel.text = tertiaryCharacter
        self.addSubview(self.tertiaryLabel)
        
        self.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "buttonSwipedUp:")
        swipeUpGestureRecognizer.direction = .Up
        self.addGestureRecognizer(swipeUpGestureRecognizer)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "buttonSwipedDown:")
        swipeDownGestureRecognizer.direction = .Down
        self.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    // MARK: Event handlers
    
    func buttonPressed(sender: KeyButton) {
        delegate?.handlePressForButton(self)
    }
    
    func buttonSwipedUp(swipeUpGestureRecognizer: UISwipeGestureRecognizer) {
        delegate?.handleSwipeUpForButton(self)
    }
    
    func buttonSwipedDown(swipeDownGestureRecognizer: UISwipeGestureRecognizer) {
        delegate?.handleSwipeDownForButton(self)
    }
}