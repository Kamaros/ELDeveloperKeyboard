//
//  CircularArray.swift
//  ELDeveloperKeyboard
//
//  Created by Eric Lin on 2014-07-02.
//  Copyright (c) 2014 Eric Lin. All rights reserved.
//

/**
    A circular array that can be cycled through.
*/
class CircularArray<T> {
    
    // MARK: Properties
        
    private let items: [T]
    
    private lazy var index = 0
        
    var currentItem: T? {
        if items.count == 0 {
            return nil
        }
        return items[index]
    }
    
    var nextItem: T? {
        if items.count == 0 {
            return nil
        }
        return index + 1 == items.count ? items[0] : items[index + 1]
    }
    
    var previousItem: T? {
        if items.count == 0 {
            return nil
        }
        return index == 0 ? items[items.count - 1] : items[index - 1]
    }
    
    // MARK: Constructors
    
    init(items: [T]) {
        self.items = items
    }
    
    // MARK: Methods
    
    func increment() {
        if items.count > 0 {
            ++index
            if index == items.count {
                index = 0
            }
        }
    }
    
    func decrement() {
        if items.count > 0 {
            --index
            if index < 0 {
                index = items.count - 1
            }
        }
    }
}