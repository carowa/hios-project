//
//  Favorites.swift
//  hiOS
//
//  Created by Harshitha Akkaraju on 3/3/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import Foundation
import CoreData

/// Wrapper on top of StorageManager to store user's favorite cryptocurrencies
class Favorites {
    static let shared = Favorites()
        
    /**
     Adds a new element to Favorites
     
     - Parameter name: Name of cryptocurrency to add to favorites list
    */
    func add(name: String) {
        StorageManager.shared.insert(favoriteWithName: name)
    }
    
    /**
     Checks whether a currency is already in Favorites
     
     - Parameter name: Name of cryptocurrency to check in favorites list
     - Returns: boolean if currency is in favorites. True if yes, False if no.
     */
    func contains(name: String) -> Bool {
        return StorageManager.shared.contains(favoriteWithName: name)
    }
    
    /**
     Removes an element from Favorites
     
     - Parameter name: Name of favorite cryptocurrency to remove
    */
    func remove(name: String) {
        StorageManager.shared.remove(favoriteWithName: name)
    }
}
