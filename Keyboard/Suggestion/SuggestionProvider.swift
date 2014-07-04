//
//  SuggestionProvider.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-03.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation

protocol SuggestionProvider {
    func suggestionsForPrefix(prefix: String) -> Array<String>
    func loadWeightedStrings(weightedStrings: Array<WeightedString>)
    func clear()
}