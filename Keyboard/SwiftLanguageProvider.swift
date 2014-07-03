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
    // TODO: Come up with actual weightings.
    var suggestionDictionary = [
        "class": 1,
        "deinit": 1,
        "enum": 1,
        "extension": 1,
        "func": 1,
        "import": 1,
        "init": 1,
        "let": 1,
        "protocol": 1,
        "static": 1,
        "struct": 1,
        "subscript": 1,
        "typealias": 1,
        "var": 1,
        "break": 1,
        "case": 1,
        "continue": 1,
        "default": 1,
        "do": 1,
        "else": 1,
        "fallthrough": 1,
        "if": 1,
        "in": 1,
        "for": 1,
        "return": 1,
        "switch": 1,
        "where": 1,
        "while": 1,
        "as": 1,
        "dynamicType": 1,
        "is": 1,
        "new": 1,
        "super": 1,
        "self": 1,
        "Self": 1,
        "Type": 1,
        "__COLUMN__": 1,
        "__FILE__": 1,
        "__FUNCTION__": 1,
        "__LINE__": 1,
        "associativity": 1,
        "didSet": 1,
        "get": 1,
        "infix": 1,
        "inout": 1,
        "left": 1,
        "mutating": 1,
        "none": 1,
        "nonmutating": 1,
        "operator": 1,
        "override": 1,
        "postfix": 1,
        "precedence": 1,
        "prefix": 1,
        "right": 1,
        "set": 1,
        "unowned": 1,
        "unowned(safe)": 1,
        "weak": 1,
        "willSet": 1
    ]
}