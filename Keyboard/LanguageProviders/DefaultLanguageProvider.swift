//
//  DefaultLanguageProvider.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation

/**
 A default implementation of the @a LanguageProvider interface, representing no specific programming language. Secondary and tertiary characters match their respective positions on a standard QWERTY keyboard.
*/
class DefaultLanguageProvider: LanguageProvider {
    var language = "Default"
    var secondaryCharacters = [
        ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"],
        ["", "", "", "~", "{", "}", "|", "-", "+"],
        ["", "", "<", ">", "?", ":", "\""]
    ]
    var tertiaryCharacters = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["", "", "", "`", "[", "]", "\\", "_", "="],
        ["", "", ",", ".", "/", ";", "'"]
    ]
    var autocapitalizeAfter = [String]()
    var suggestionDictionary = [WeightedString]()
}