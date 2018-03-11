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

    // FIXME: Probably should use the swift 'count' name
    /**
     Gets the count of favorites list
     
     - Returns: An Int representing the count of favorites list
    */
    func size() -> Int {
        return StorageManager.shared.fetchAllFavorites().count
    }
    
    /**
     Gets the list of user's favorite cryptocurrencies
     
     - Returns: An array of Strings with ids of cryptocurrencies
    */
    func getList() -> [FavoriteItem] {
        // FIXME: Actual implementation
        return StorageManager.shared.fetchAllFavorites()
    }
    
    /**
     Gets the crypto currency object with the given id
     
     - Parameter id: A String representing the id of a cryptocurrency
     - Returns: A Cryptocurrency object
    */
    func getElemById(id : String) -> Cryptocurrency {
        return CryptoRepo.shared.getElemById(id: id)
    }

    /**
     Removes a favorite with the given name, if it exists
     
     - Parameter name: A String representing the name of the element to delete
    */
    func remove(name: String) {
        StorageManager.shared.remove(favoriteWithName: name)
    }
}
