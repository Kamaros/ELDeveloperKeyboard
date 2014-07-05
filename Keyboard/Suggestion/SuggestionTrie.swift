//
//  SuggestionTrie.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-03.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

import Foundation

/**
 An implementation of the @a SuggestionProvider protocol that uses a ternary search tree (trie) to store and search for terms.
*/
class SuggestionTrie: SuggestionProvider {
    
    // MARK: Properties

    var root: SuggestionNode?
    
    // MARK: Constructors
    
    init() {}
    
    // MARK: SuggestionProvider

    func suggestionsForPrefix(prefix: String) -> Array<String> {
        if let node = searchForNodeMatchingPrefix(prefix, rootNode: root) {
            var weightedSuggestions = Array<WeightedString>()
            findSuggestionsForNode(node.equalKid, suggestions: &weightedSuggestions)
            weightedSuggestions.sort() { $0.weight >= $1.weight }
            var suggestions = Array<String>()
            for suggestion in weightedSuggestions {
                suggestions += suggestion.term
            }
            return suggestions
        }
        return []
    }
    
    func loadWeightedStrings(weightedStrings: Array<WeightedString>) {
        for ws in weightedStrings {
            insertString(ws.term, weight: ws.weight)
        }
    }
    
    func clear() {
        deleteNode(&root)
    }
    
    // MARK: Helper Methods
    
    func insertString(s: String, weight: Int) {
        if let node = searchForNodeMatchingPrefix(s, rootNode: root) {
            node.isWordEnd = true
            node.weight = weight
        } else {
            insertString(s, charIndex: 0, weight: weight, node: &root)
        }
    }

    func insertString(s: String, charIndex: Int, weight: Int, inout node: SuggestionNode?) {
        let count = countElements(s)
        if count > 0 {
            if !node {
                if count == charIndex + 1 {
                    node = SuggestionNode(term: s, weight: weight)
                } else {
                    node = SuggestionNode(term: s[0..charIndex + 1])
                }
            }

            if s[charIndex] < node!.char {
                insertString(s, charIndex: charIndex, weight: weight, node: &node!.loKid)
            } else if s[charIndex] > node!.char {
                insertString(s, charIndex: charIndex, weight: weight, node: &node!.hiKid)
            } else if count > charIndex + 1 {
                insertString(s, charIndex: charIndex + 1, weight: weight, node: &node!.equalKid)
            }
        }
    }
    
    func searchForNodeMatchingPrefix(prefix: String, rootNode: SuggestionNode?) -> SuggestionNode? {
        let count = countElements(prefix)
        if !rootNode || count == 0 {
            return nil
        } else if count == 1 && prefix == rootNode!.char {
            return rootNode
        }
        
        if prefix[0] < rootNode!.char {
            return searchForNodeMatchingPrefix(prefix, rootNode: rootNode!.loKid)
        } else if prefix[0] > rootNode!.char {
            return searchForNodeMatchingPrefix(prefix, rootNode: rootNode!.hiKid)
        } else {
            return searchForNodeMatchingPrefix(prefix[1..count], rootNode: rootNode!.equalKid)
        }
    }
    
    func findSuggestionsForNode(node: SuggestionNode?, inout suggestions: Array<WeightedString>) {
        if let n = node {
            if n.isWordEnd {
                suggestions += WeightedString(term: n.term, weight: n.weight)
            }
            
            findSuggestionsForNode(n.loKid, suggestions: &suggestions)
            findSuggestionsForNode(n.equalKid, suggestions: &suggestions)
            findSuggestionsForNode(n.hiKid, suggestions: &suggestions)
        }
    }
    
    func deleteNode(inout node: SuggestionNode?) {
        if let n = node {
            deleteNode(&n.loKid)
            deleteNode(&n.equalKid)
            deleteNode(&n.hiKid)
            node = nil
        }
    }
    
    /**
     A @a SuggestionTrie node, representing a term.
    */
    class SuggestionNode {
        
        // MARK: Properties

        let term: String
        var weight: Int
        var char: String {
            return term[countElements(term) - 1]
        }
        var isWordEnd: Bool
        
        var loKid: SuggestionNode?
        var equalKid: SuggestionNode?
        var hiKid: SuggestionNode?
        
        // MARK: Constructors
        
        init(term: String, isWordEnd: Bool, weight: Int) {
            self.term = term
            self.isWordEnd = isWordEnd
            self.weight = weight
        }
        
        convenience init(term: String, weight: Int) {
            self.init(term: term, isWordEnd: true, weight: weight)
        }
        
        convenience init(term: String) {
            self.init(term: term, isWordEnd: false, weight: 0)
        }
    }
}