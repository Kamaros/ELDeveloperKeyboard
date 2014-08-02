//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation
import UIKit

/**
 An iOS custom keyboard extension written in Swift designed to make it much, much easier to type code on an iOS device.
*/
class KeyboardViewController: UIInputViewController, CharacterButtonDelegate, SuggestionButtonDelegate, TouchForwardingViewDelegate {
    
    // MARK: Constants
    
    private var mutablePrimaryCharacters = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"]
    ]

    private let primaryCharacters = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"]
    ]
    
    private let suggestionProvider: SuggestionProvider = SuggestionTrie()
    
    private let languageProviders = CircularArray(items: [DefaultLanguageProvider(), SwiftLanguageProvider()] as [LanguageProvider])
    
    private let spacing: CGFloat = 4.0
    private let predictiveTextBoxHeight: CGFloat = 24.0
    private var predictiveTextButtonWidth: CGFloat {
        return (self.view.frame.width - 4 * spacing) / 3.0
    }
    private var keyWidth: CGFloat {
        return (self.view.frame.width - 11 * spacing) / 10.0
    }
    private var keyHeight: CGFloat {
        return (self.view.frame.height - 5 * spacing - predictiveTextBoxHeight) / 4.0
    }
    
    // MARK: Interface
    
    private var swipeView: SwipeView!
    private var predictiveTextScrollView: PredictiveTextScrollView!
    private var suggestionButtons = [SuggestionButton]()
    
    private lazy var characterButtons: [[CharacterButton]] = [
        [],
        [],
        []
    ]
    private var shiftButton: KeyButton!
    private var deleteButton: KeyButton!
    private var tabButton: KeyButton!
    private var nextKeyboardButton: KeyButton!
    private var spaceButton: KeyButton!
    private var returnButton: KeyButton!
    private var currentLanguageLabel: UILabel!
    
    // MARK: Timers
    
    private var deleteButtonTimer: NSTimer?
    private var spaceButtonTimer: NSTimer?
    
    // MARK: Properties
    
    private var proxy: UITextDocumentProxy {
        return self.textDocumentProxy as UITextDocumentProxy
    }
    
    private var lastWordTyped: String? {
        if let documentContextBeforeInput = proxy.documentContextBeforeInput?.bridgeToObjectiveC() {
            let length = documentContextBeforeInput.length
            if length > 0 && NSCharacterSet.letterCharacterSet().characterIsMember(documentContextBeforeInput.characterAtIndex(length - 1)) {
                let components = documentContextBeforeInput.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacterSet().invertedSet) as [String]
                return components[components.endIndex - 1]
            }
        }
        return nil
    }
    
    private var languageProvider: LanguageProvider {
        didSet {
            for (rowIndex, row) in enumerate(characterButtons) {
                for (characterButtonIndex, characterButton) in enumerate(row) {
                    characterButton.secondaryCharacter = languageProvider.secondaryCharacters[rowIndex][characterButtonIndex]
                    characterButton.tertiaryCharacter = languageProvider.tertiaryCharacters[rowIndex][characterButtonIndex]
                }
            }
            currentLanguageLabel.text = languageProvider.language
            suggestionProvider.clear()
            suggestionProvider.loadWeightedStrings(languageProvider.suggestionDictionary)
        }
    }
    
    private enum ShiftMode {
        case Off, On, Caps
    }
    
    private var shiftMode: ShiftMode {
        didSet {
            shiftButton.selected = (shiftMode == .Caps)
            for row in characterButtons {
                for characterButton in row {
                    switch shiftMode {
                    case .Off:
                        characterButton.primaryLabel.text = characterButton.primaryCharacter.lowercaseString
                    case .On, .Caps:
                        characterButton.primaryLabel.text = characterButton.primaryCharacter.uppercaseString
                    }
                
                }
            }
        }
    }
    
    // MARK: Constructors
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.shiftMode = .Off
        self.languageProvider = languageProviders.currentItem!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: Overridden methods
    
    override func loadView() {
        let screenRect = UIScreen.mainScreen().bounds
        self.view = TouchForwardingView(frame: CGRectMake(0.0, 0.0, screenRect.width, screenRect.height), delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 12.0/255, green: 12.0/255, blue: 12.0/255, alpha: 1)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initializeKeyboard()
    }
        
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        initializeKeyboard()
    }
    
    // MARK: Event handlers
    
    func shiftButtonPressed(sender: KeyButton) {
        switch shiftMode {
        case .Off:
            shiftMode = .On
        case .On:
            shiftMode = .Caps
        case .Caps:
            shiftMode = .Off
        }
    }
    
    func deleteButtonPressed(sender: KeyButton) {
        switch proxy.documentContextBeforeInput {
        case let s where s?.hasSuffix("    ") == true: // Cursor in front of tab, so delete tab.
            for i in 0..<4 { // TODO: Update to use tab setting.
                proxy.deleteBackward()
            }
        default:
            proxy.deleteBackward()
        }
        updateSuggestions()
    }
    
    func handleLongPressForDeleteButtonWithGestureRecognizer(gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            if !deleteButtonTimer {
                deleteButtonTimer = NSTimer(timeInterval: 0.1, target: self, selector: "handleDeleteButtonTimerTick:", userInfo: nil, repeats: true)
                deleteButtonTimer!.tolerance = 0.01
                NSRunLoop.mainRunLoop().addTimer(deleteButtonTimer, forMode: NSDefaultRunLoopMode)
            }
        default:
            deleteButtonTimer?.invalidate()
            deleteButtonTimer = nil
            updateSuggestions()
        }
    }
    
    func handleSwipeLeftForDeleteButtonWithGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        // TODO: Figure out an implementation that doesn't use bridgeToObjectiveC, in case of funny unicode characters.
        if let documentContextBeforeInput = proxy.documentContextBeforeInput?.bridgeToObjectiveC() {
            if documentContextBeforeInput.length > 0 {
                var charactersToDelete = 0
                switch documentContextBeforeInput {
                case let s where NSCharacterSet.letterCharacterSet().characterIsMember(s.characterAtIndex(s.length - 1)): // Cursor in front of letter, so delete up to first non-letter character.
                    let range = documentContextBeforeInput.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet().invertedSet, options: .BackwardsSearch)
                    if range.location != NSNotFound {
                        charactersToDelete = documentContextBeforeInput.length - range.location - 1
                    } else {
                        charactersToDelete = documentContextBeforeInput.length
                    }
                case let s where s.hasSuffix(" "): // Cursor in front of whitespace, so delete up to first non-whitespace character.
                    let range = documentContextBeforeInput.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet().invertedSet, options: .BackwardsSearch)
                    if range.location != NSNotFound {
                        charactersToDelete = documentContextBeforeInput.length - range.location - 1
                    } else {
                        charactersToDelete = documentContextBeforeInput.length
                    }
                default: // Just delete last character.
                    charactersToDelete = 1
                }
                
                for i in 0..<charactersToDelete {
                    proxy.deleteBackward()
                }
            }
        }
        updateSuggestions()
    }
    
    func handleDeleteButtonTimerTick(timer: NSTimer) {
        proxy.deleteBackward()
    }
    
    func tabButtonPressed(sender: KeyButton) {
        for i in 0..<4 { // TODO: Update to use tab setting.
            proxy.insertText(" ")
        }
    }
    
    func spaceButtonPressed(sender: KeyButton) {
        for suffix in languageProvider.autocapitalizeAfter {
            if proxy.documentContextBeforeInput.hasSuffix(suffix) {
                shiftMode = .On
            }
        }
        proxy.insertText(" ")
        updateSuggestions()
    }
    
    func handleLongPressForSpaceButtonWithGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            if !spaceButtonTimer {
                spaceButtonTimer = NSTimer(timeInterval: 0.1, target: self, selector: "handleSpaceButtonTimerTick:", userInfo: nil, repeats: true)
                spaceButtonTimer!.tolerance = 0.01
                NSRunLoop.mainRunLoop().addTimer(spaceButtonTimer, forMode: NSDefaultRunLoopMode)
            }
        default:
            spaceButtonTimer?.invalidate()
            spaceButtonTimer = nil
            updateSuggestions()
        }
    }
    
    func handleSpaceButtonTimerTick(timer: NSTimer) {
        proxy.insertText(" ")
    }
    
    func handleSwipeLeftForSpaceButtonWithGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(0.1, animations: {
            self.moveButtonLabels(-self.keyWidth)
            }, completion: {
                (success: Bool) -> Void in
                self.languageProviders.increment()
                self.languageProvider = self.languageProviders.currentItem!
                self.moveButtonLabels(self.keyWidth * 2.0)
                UIView.animateWithDuration(0.1) {
                    self.moveButtonLabels(-self.keyWidth)
                }
            }
        )
    }
    
    func handleSwipeRightForSpaceButtonWithGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(0.1, animations: {
            self.moveButtonLabels(self.keyWidth)
            }, completion: {
                (success: Bool) -> Void in
                self.languageProviders.decrement()
                self.languageProvider = self.languageProviders.currentItem!
                self.moveButtonLabels(-self.keyWidth * 2.0)
                UIView.animateWithDuration(0.1) {
                    self.moveButtonLabels(self.keyWidth)
                }
            }
        )
    }
    
    func returnButtonPressed(sender: KeyButton) {
        proxy.insertText("\n")
        updateSuggestions()
    }
    
    // MARK: CharacterButtonDelegate
    
    func handlePressForButton(button: CharacterButton) {
        switch shiftMode {
        case .Off:
            proxy.insertText(button.primaryCharacter.lowercaseString)
        case .On:
            proxy.insertText(button.primaryCharacter.uppercaseString)
            shiftMode = .Off
        case .Caps:
            proxy.insertText(button.primaryCharacter.uppercaseString)
        }
        updateSuggestions()
    }
    
    func handleSwipeUpForButton(button: CharacterButton) {
        proxy.insertText(button.secondaryCharacter)
        if countElements(button.secondaryCharacter) > 1 {
            proxy.insertText(" ")
        }
        updateSuggestions()
    }
    
    func handleSwipeDownForButton(button: CharacterButton) {
        proxy.insertText(button.tertiaryCharacter)
        if countElements(button.tertiaryCharacter) > 1 {
            proxy.insertText(" ")
        }
        updateSuggestions()
    }
    
    // MARK: SuggestionButtonDelegate
    
    func handlePressForButton(button: SuggestionButton) {
        if let lastWord = lastWordTyped {
            for letter in lastWord {
                proxy.deleteBackward()
            }
            proxy.insertText(button.title + " ")
            for suggestionButton in suggestionButtons {
                suggestionButton.removeFromSuperview()
            }
        }
    }
    
    // MARK: TouchForwardingViewDelegate
    
    // TODO: Get this method to properly provide the desired behaviour.
    func viewForHitTestWithPoint(point: CGPoint, event: UIEvent, superResult: UIView) -> UIView {
        for subview in view.subviews as [UIView] {
            let convertPoint = subview.convertPoint(point, fromView: view)
            if subview.pointInside(convertPoint, withEvent: event) {
                return subview
            }
        }
        return superResult
    }
    
    // MARK: Helper methods
    
    private func initializeKeyboard() {
        for subview in self.view.subviews as [UIView] {
            subview.removeFromSuperview() // Remove all buttons and gesture recognizers when view is recreated during orientation changes.
        }

        addPredictiveTextScrollView()
        addShiftButton()
        addDeleteButton()
        addTabButton()
        addNextKeyboardButton()
        addSpaceButton()
        addReturnButton()
        addCharacterButtons()
        addSwipeView()
    }
    
    private func addPredictiveTextScrollView() {
        predictiveTextScrollView = PredictiveTextScrollView(frame: CGRectMake(0.0, 0.0, self.view.frame.width, predictiveTextBoxHeight))
        self.view.addSubview(predictiveTextScrollView)
    }
    
    private func addShiftButton() {
        shiftButton = KeyButton(frame: CGRectMake(spacing, keyHeight * 2.0 + spacing * 3.0 + predictiveTextBoxHeight, keyWidth * 1.5 + spacing * 0.5, keyHeight))
        shiftButton.setTitle("\u{000021E7}", forState: .Normal)
        shiftButton.addTarget(self, action: "shiftButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(shiftButton)
    }
    
    private func addDeleteButton() {
        deleteButton = KeyButton(frame: CGRectMake(keyWidth * 8.5 + spacing * 9.5, keyHeight * 2.0 + spacing * 3.0 + predictiveTextBoxHeight, keyWidth * 1.5, keyHeight))
        deleteButton.setTitle("\u{0000232B}", forState: .Normal)
        deleteButton.addTarget(self, action: "deleteButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(deleteButton)
        
        let deleteButtonLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressForDeleteButtonWithGestureRecognizer:")
        deleteButton.addGestureRecognizer(deleteButtonLongPressGestureRecognizer)
        
        let deleteButtonSwipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeLeftForDeleteButtonWithGestureRecognizer:")
        deleteButtonSwipeLeftGestureRecognizer.direction = .Left
        deleteButton.addGestureRecognizer(deleteButtonSwipeLeftGestureRecognizer)
    }
    
    private func addTabButton() {
        tabButton = KeyButton(frame: CGRectMake(spacing, keyHeight * 3.0 + spacing * 4.0 + predictiveTextBoxHeight, keyWidth * 1.5 + spacing * 0.5, keyHeight))
        tabButton.setTitle("tab", forState: .Normal)
        tabButton.addTarget(self, action: "tabButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(tabButton)
    }
    
    private func addNextKeyboardButton() {
        nextKeyboardButton = KeyButton(frame: CGRectMake(keyWidth * 1.5 + spacing * 2.5, keyHeight * 3.0 + spacing * 4.0 + predictiveTextBoxHeight, keyWidth, keyHeight))
        nextKeyboardButton.setTitle("\u{0001F310}", forState: .Normal)
        nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        self.view.addSubview(nextKeyboardButton)
    }
    
    private func addSpaceButton() {
        spaceButton = KeyButton(frame: CGRectMake(keyWidth * 2.5 + spacing * 3.5, keyHeight * 3.0 + spacing * 4.0 + predictiveTextBoxHeight, keyWidth * 5.0 + spacing * 4.0, keyHeight))
        spaceButton.addTarget(self, action: "spaceButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(spaceButton)
        
        currentLanguageLabel = UILabel(frame: CGRectMake(0.0, 0.0, spaceButton.frame.width, spaceButton.frame.height * 0.33))
        currentLanguageLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        currentLanguageLabel.adjustsFontSizeToFitWidth = true
        currentLanguageLabel.textColor = UIColor(white: 187.0/255, alpha: 1)
        currentLanguageLabel.textAlignment = .Center
        currentLanguageLabel.text = "\(languageProvider.language)"
        spaceButton.addSubview(currentLanguageLabel)
        
        let spaceButtonLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressForSpaceButtonWithGestureRecognizer:")
        spaceButton.addGestureRecognizer(spaceButtonLongPressGestureRecognizer)
        
        let spaceButtonSwipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeLeftForSpaceButtonWithGestureRecognizer:")
        spaceButtonSwipeLeftGestureRecognizer.direction = .Left
        spaceButton.addGestureRecognizer(spaceButtonSwipeLeftGestureRecognizer)
        
        let spaceButtonSwipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeRightForSpaceButtonWithGestureRecognizer:")
        spaceButtonSwipeRightGestureRecognizer.direction = .Right
        spaceButton.addGestureRecognizer(spaceButtonSwipeRightGestureRecognizer)
    }
    
    private func addReturnButton() {
        returnButton = KeyButton(frame: CGRectMake(keyWidth * 7.5 + spacing * 8.5, keyHeight * 3.0 + spacing * 4.0 + predictiveTextBoxHeight, keyWidth * 2.5 + spacing, keyHeight))
        returnButton.setTitle("\u{000023CE}", forState: .Normal)
        returnButton.addTarget(self, action: "returnButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(returnButton)
    }
    
    private func addCharacterButtons() {
        characterButtons = [
            [],
            [],
            []
        ] // Clear characterButtons array.
        
        var y = spacing + predictiveTextBoxHeight
        for (rowIndex, row) in enumerate(primaryCharacters) {
            var x: CGFloat
            switch rowIndex {
            case 1:
                x = spacing * 1.5 + keyWidth * 0.5
            case 2:
                x = spacing * 2.5 + keyWidth * 1.5
            default:
                x = spacing
            }
            for (keyIndex, key) in enumerate(row) {
                let characterButton = CharacterButton(frame: CGRectMake(x, y, keyWidth, keyHeight), primaryCharacter: key, secondaryCharacter: languageProvider.secondaryCharacters[rowIndex][keyIndex], tertiaryCharacter: languageProvider.tertiaryCharacters[rowIndex][keyIndex], delegate: self)
                self.view.addSubview(characterButton)
                characterButtons[rowIndex] += characterButton
                x += keyWidth + spacing
            }
            y += keyHeight + spacing
        }
    }
    
    private func addSwipeView() {
        swipeView = SwipeView(containerView: self.view, topOffset: predictiveTextBoxHeight)
        self.view.addSubview(swipeView)
    }
    
    private func moveButtonLabels(dx: CGFloat) {
        for (rowIndex, row) in enumerate(characterButtons) {
            for (characterButtonIndex, characterButton) in enumerate(row) {
                characterButton.secondaryLabel.frame.offset(dx: dx, dy: 0.0)
                characterButton.tertiaryLabel.frame.offset(dx: dx, dy: 0.0)
            }
        }
        currentLanguageLabel.frame.offset(dx: dx, dy: 0.0)
    }
    
    private func updateSuggestions() {
        for suggestionButton in suggestionButtons {
            suggestionButton.removeFromSuperview()
        }
        
        // TODO: Figure out an implementation that doesn't use bridgeToObjectiveC, in case of funny unicode characters.
        if let lastWord = lastWordTyped {
            var x = spacing
            for suggestion in suggestionProvider.suggestionsForPrefix(lastWord) {
                let suggestionButton = SuggestionButton(frame: CGRectMake(x, 0.0, predictiveTextButtonWidth, predictiveTextBoxHeight), title: suggestion, delegate: self)
                predictiveTextScrollView?.addSubview(suggestionButton)
                suggestionButtons += suggestionButton
                x += predictiveTextButtonWidth + spacing
            }
            predictiveTextScrollView!.contentSize = CGSizeMake(x, predictiveTextBoxHeight)
        }
    }
}