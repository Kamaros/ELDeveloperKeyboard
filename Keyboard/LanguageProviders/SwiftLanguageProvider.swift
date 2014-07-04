//
//  SwiftLanguageProvider.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation

class SwiftLanguageProvider: LanguageProvider {
    var language = "Swift"
    var secondaryCharacters = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["if", "do", "@", "~", "+", "-", ":", "{", "}"],
        ["for", "switch", "*", "&", "(", ")", "\""]
    ]
    var tertiaryCharacters = [
        ["var", "let", "#", "`", "%", "<", ">", "?", "!", "="],
        ["else", "while", "$", "^", "|", "_", ";", "[", "]"],
        ["in", "case", "/", "\\", ",", ".", "'"]
    ]
    var autocapitalizeAfter = ["class", "struct", "enum", "protocol", "extension", "import", "typealias", ":", "->"]
    // TODO: Come up with actual weightings, and stop this from being alphabetical.
    var suggestionDictionary = [
        WeightedString(term: "class", weight: 1),
        WeightedString(term: "deinit", weight: 1),
        WeightedString(term: "enum", weight: 1),
        WeightedString(term: "extension", weight: 1),
        WeightedString(term: "func", weight: 1),
        WeightedString(term: "import", weight: 1),
        WeightedString(term: "init", weight: 1),
        WeightedString(term: "let", weight: 1),
        WeightedString(term: "protocol", weight: 1),
        WeightedString(term: "static", weight: 1),
        WeightedString(term: "struct", weight: 1),
        WeightedString(term: "subscript", weight: 1),
        WeightedString(term: "typealias", weight: 1),
        WeightedString(term: "var", weight: 1),
        WeightedString(term: "break", weight: 1),
        WeightedString(term: "case", weight: 1),
        WeightedString(term: "continue", weight: 1),
        WeightedString(term: "default", weight: 1),
        WeightedString(term: "do", weight: 1),
        WeightedString(term: "else", weight: 1),
        WeightedString(term: "fallthrough", weight: 1),
        WeightedString(term: "if", weight: 1),
        WeightedString(term: "in", weight: 1),
        WeightedString(term: "for", weight: 1),
        WeightedString(term: "return", weight: 1),
        WeightedString(term: "switch", weight: 1),
        WeightedString(term: "where", weight: 1),
        WeightedString(term: "while", weight: 1),
        WeightedString(term: "as", weight: 1),
        WeightedString(term: "dynamicType", weight: 1),
        WeightedString(term: "is", weight: 1),
        WeightedString(term: "new", weight: 1),
        WeightedString(term: "super", weight: 1),
        WeightedString(term: "self", weight: 1),
        WeightedString(term: "Self", weight: 1),
        WeightedString(term: "Type", weight: 1),
        WeightedString(term: "__COLUMN__", weight: 1),
        WeightedString(term: "__FILE__", weight: 1),
        WeightedString(term: "__FUNCTION__", weight: 1),
        WeightedString(term: "__LINE__", weight: 1),
        WeightedString(term: "associativity", weight: 1),
        WeightedString(term: "didSet", weight: 1),
        WeightedString(term: "get", weight: 1),
        WeightedString(term: "infix", weight: 1),
        WeightedString(term: "inout", weight: 1),
        WeightedString(term: "left", weight: 1),
        WeightedString(term: "mutating", weight: 1),
        WeightedString(term: "none", weight: 1),
        WeightedString(term: "nonmutating", weight: 1),
        WeightedString(term: "operator", weight: 1),
        WeightedString(term: "override", weight: 1),
        WeightedString(term: "postfix", weight: 1),
        WeightedString(term: "precedence", weight: 1),
        WeightedString(term: "prefix", weight: 1),
        WeightedString(term: "right", weight: 1),
        WeightedString(term: "set", weight: 1),
        WeightedString(term: "unowned", weight: 1),
        WeightedString(term: "unowned(safe)", weight: 1),
        WeightedString(term: "weak", weight: 1),
        WeightedString(term: "willSet", weight: 1)
    ]
}