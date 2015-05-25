//
//  SwiftLanguageProvider.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation

/**
    An implementation of the LanguageProvider interface, targeted towards the Swift programming language.
*/
class SwiftLanguageProvider: LanguageProvider {
    lazy var language = "Swift"
    lazy var secondaryCharacters = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["if", "do", "@", "~", "+", "-", ":", "{", "}"],
        ["for", "switch", "*", "&", "(", ")", "\""]
    ]
    
    lazy var tertiaryCharacters = [
        ["var", "let", "#", "`", "%", "<", ">", "?", "!", "="],
        ["else", "while", "$", "^", "|", "_", ";", "[", "]"],
        ["in", "case", "/", "\\", ",", ".", "'"]
    ]
    lazy var autocapitalizeAfter = ["class", "struct", "enum", "protocol", "extension", "import", "typealias", ":", "->"]
    lazy var suggestionDictionary = [
        WeightedString(term: "self", weight: 133),
        WeightedString(term: "func", weight: 57),
        WeightedString(term: "var", weight: 49),
        WeightedString(term: "frame", weight: 45),
        WeightedString(term: "let", weight: 38),
        WeightedString(term: "if", weight: 38),
        WeightedString(term: "String", weight: 35),
        WeightedString(term: "in", weight: 29),
        WeightedString(term: "return", weight: 25),
        WeightedString(term: "Array", weight: 22),
        WeightedString(term: "Dictionary", weight: 22),
        WeightedString(term: "Set", weight: 22),
        WeightedString(term: "for", weight: 21),
        WeightedString(term: "while", weight: 20),
        WeightedString(term: "import", weight: 19),
        WeightedString(term: "view", weight: 18),
        WeightedString(term: "case", weight: 18),
        WeightedString(term: "init", weight: 17),
        WeightedString(term: "delegate", weight: 16),
        WeightedString(term: "true", weight: 12),
        WeightedString(term: "class", weight: 10),
        WeightedString(term: "text", weight: 10),
        WeightedString(term: "nil", weight: 10),
        WeightedString(term: "super", weight: 10),
        WeightedString(term: "else", weight: 9),
        WeightedString(term: "protocol", weight: 9),
        WeightedString(term: "enum", weight: 9),
        WeightedString(term: "struct", weight: 9),
        WeightedString(term: "switch", weight: 8),
        WeightedString(term: "Int", weight: 8),
        WeightedString(term: "Double", weight: 8),
        WeightedString(term: "width", weight: 8),
        WeightedString(term: "height", weight: 8),
        WeightedString(term: "size", weight: 7),
        WeightedString(term: "override", weight: 7),
        WeightedString(term: "enumerate", weight: 6),
        WeightedString(term: "is", weight: 6),
        WeightedString(term: "didSet", weight: 6),
        WeightedString(term: "willSet", weight: 6),
        WeightedString(term: "as", weight: 6),
        WeightedString(term: "static", weight: 5),
        WeightedString(term: "Bool", weight: 5),
        WeightedString(term: "get", weight: 5),
        WeightedString(term: "set", weight: 5),
        WeightedString(term: "do", weight: 5),
        WeightedString(term: "countElements", weight: 5),
        WeightedString(term: "TODO",weight: 4),
        WeightedString(term: "extension", weight: 4),
        WeightedString(term: "where", weight: 3),
        WeightedString(term: "inout", weight: 3),
        WeightedString(term: "mutating", weight: 3),
        WeightedString(term: "convenience", weight: 2),
        WeightedString(term: "unowned", weight: 2),
        WeightedString(term: "unowned(safe)", weight: 2),
        WeightedString(term: "weak", weight: 2),
        WeightedString(term: "continue", weight: 2),
        WeightedString(term: "operator", weight: 2),
        WeightedString(term: "break", weight: 2),
        WeightedString(term: "default", weight: 2),
        WeightedString(term: "__FILE__", weight: 1),
        WeightedString(term: "deinit", weight: 1),
        WeightedString(term: "subscript", weight: 1),
        WeightedString(term: "typealias", weight: 1),
        WeightedString(term: "fallthrough", weight: 1),
        WeightedString(term: "dynamicType", weight: 1),
        WeightedString(term: "__FUNCTION__", weight: 1),
        WeightedString(term: "new", weight: 1),
        WeightedString(term: "Self", weight: 1),
        WeightedString(term: "Type", weight: 1),
        WeightedString(term: "associativity", weight: 1),
        WeightedString(term: "postfix", weight: 1),
        WeightedString(term: "precedence", weight: 1),
        WeightedString(term: "infix", weight: 1),
        WeightedString(term: "left", weight: 1),
        WeightedString(term: "__LINE__", weight: 1),
        WeightedString(term: "none", weight: 1),
        WeightedString(term: "nonmutating", weight: 1),
        WeightedString(term: "prefix", weight: 1),
        WeightedString(term: "right", weight: 1),
        WeightedString(term: "__COLUMN__", weight: 1),
    ]
}