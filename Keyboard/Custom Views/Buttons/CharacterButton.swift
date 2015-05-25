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
    The methods declared in the CharacterButtonDelegate protocol allow the adopting delegate to respond to messages from the CharacterButton class, handling button presses and swipes.
*/
protocol CharacterButtonDelegate: class {
    /**
        Respond to the CharacterButton being pressed.
        
        :param: button The CharacterButton that was pressed.
    */
    func handlePressForCharacterButton(button: CharacterButton)
    
    /**
        Respond to the CharacterButton being up-swiped.
     
        :param: button The CharacterButton that was up-swiped.
    */
    func handleSwipeUpForButton(button: CharacterButton)
    
    /**
        Respond to the CharacterButton being down-swiped.
     
        :param: button The CharacterButton that was down-swiped.
    */
    func handleSwipeDownForButton(button: CharacterButton)
}

/**
    CharacterButton is a KeyButton subclass associated with three characters (primary, secondary, and tertiary) as well as three gestures (press, swipe up, and swipe down).
*/
class CharacterButton: KeyButton {
    
    // MARK: Properties
    
    weak var delegate: CharacterButtonDelegate?
    
    var primaryCharacter: String {
        didSet {
            if primaryLabel != nil {
                primaryLabel.text = primaryCharacter
            }
        }
    }
    var secondaryCharacter: String {
        didSet {
            if secondaryLabel != nil {
                secondaryLabel.text = secondaryCharacter
            }
        }
    }
    var tertiaryCharacter: String {
        didSet {
            if tertiaryLabel != nil {
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
        
        primaryLabel = UILabel(frame: CGRectMake(frame.width * 0.2, 0.0, frame.width * 0.8, frame.height * 0.95))
        primaryLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        primaryLabel.textColor = UIColor(white: 238.0/255, alpha: 1.0)
        primaryLabel.textAlignment = .Left
        primaryLabel.text = primaryCharacter
        addSubview(primaryLabel)
        
        secondaryLabel = UILabel(frame: CGRectMake(0.0, 0.0, frame.width * 0.9, frame.height * 0.3))
        secondaryLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        secondaryLabel.adjustsFontSizeToFitWidth = true
        secondaryLabel.textColor = UIColor(white: 187.0/255, alpha: 1.0)
        secondaryLabel.textAlignment = .Right
        secondaryLabel.text = secondaryCharacter
        addSubview(secondaryLabel)
        
        tertiaryLabel = UILabel(frame: CGRectMake(0.0, frame.height * 0.65, frame.width * 0.9, frame.height * 0.25))
        tertiaryLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        tertiaryLabel.textColor = UIColor(white: 187.0/255, alpha: 1.0)
        tertiaryLabel.adjustsFontSizeToFitWidth = true
        tertiaryLabel.textAlignment = .Right
        tertiaryLabel.text = tertiaryCharacter
        addSubview(tertiaryLabel)
        
        addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "buttonSwipedUp:")
        swipeUpGestureRecognizer.direction = .Up
        addGestureRecognizer(swipeUpGestureRecognizer)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "buttonSwipedDown:")
        swipeDownGestureRecognizer.direction = .Down
        addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Event handlers
    
    func buttonPressed(sender: KeyButton) {
        delegate?.handlePressForCharacterButton(self)
    }
    
    func buttonSwipedUp(swipeUpGestureRecognizer: UISwipeGestureRecognizer) {
        delegate?.handleSwipeUpForButton(self)
    }
    
    func buttonSwipedDown(swipeDownGestureRecognizer: UISwipeGestureRecognizer) {
        delegate?.handleSwipeDownForButton(self)
    }
}