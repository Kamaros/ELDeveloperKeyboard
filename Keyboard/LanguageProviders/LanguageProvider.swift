//
//  LanguageProvider.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation

protocol LanguageProvider {
    var language: String { get }
    var secondaryCharacters: Array<Array<String>> { get }
    var tertiaryCharacters: Array<Array<String>> { get }
    var autocapitalizeAfter: Array<String> { get }
    var suggestionDictionary: Array<WeightedString> { get }
}