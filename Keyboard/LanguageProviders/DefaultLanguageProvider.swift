//
//  DefaultLanguageProvider.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation

/**
    A default implementation of the LanguageProvider interface, representing no specific programming language. Secondary and tertiary characters match their respective positions on a standard QWERTY keyboard.
*/
class DefaultLanguageProvider: LanguageProvider {
    lazy var language = "Default"
    lazy var secondaryCharacters = [
        ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"],
        ["", "", "", "~", "{", "}", "|", "-", "+"],
        ["", "", "<", ">", "?", ":", "\""]
    ]
    lazy var tertiaryCharacters = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["", "", "", "`", "[", "]", "\\", "_", "="],
        ["", "", ",", ".", "/", ";", "'"]
    ]
    lazy var autocapitalizeAfter = [String]()
    lazy var suggestionDictionary = [WeightedString]()
}