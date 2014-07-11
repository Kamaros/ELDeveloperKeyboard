//
//  SuggestionProvider.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-03.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation

/**
 The @a SuggestionProvider protocol defines an interface for loading a list of weighted terms and providing autosuggest suggestions from those terms.
*/
protocol SuggestionProvider {
    /**
     Returns a list of autosuggest suggestions that begin with the prefix string provided.
     @param prefix
            The prefix string that suggestions begin with.
    */
    func suggestionsForPrefix(prefix: String) -> [String]
    
    /**
     Loads autosuggest terms.
     @param weightedStrings
            A list of @a WeightedStrings representing autosuggest terms and their relative frequencies.
    */
    func loadWeightedStrings(weightedStrings: [WeightedString])
    
    /**
     Clears previously loaded autosuggest terms.
    */
    func clear()
}