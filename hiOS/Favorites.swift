//
//  Favorites.swift
//  hiOS
//
//  Created by Harshitha Akkaraju on 3/3/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import Foundation

/// Singleton object to store user's favorite cryptocurrencies
class FavoritesRepo {
    static let shared = FavoritesRepo()
    
    private var list : [String] = []
    let cryptoRepo = CryptoRepo.shared
    
    /**
     Adds a new element to FavoritesRepo
     
     - Parameter name: Name of favorite cryptocurrency to add
    */
    func add(name : String) {
        // FIXME: Add a contains method in CryptoRepo and make sure that such a cryptocurrency exists
        list.append(name)
    }
    
    /**
     Removes an element from FavoritesRepo
     
     - Parameter name: Name of favorite cryptocurrency to remove
    */
    func remove(name : String) {
        let index = findItem(name: name)
        if (index != -1) {
            list.remove(at: index)
        }
    }
    
    /**
     Helper function to find the index of an element
     
     - Parameter name: Name of the favorite cryptocurrency to find
     - Returns: The index of the element or -1 if the element is not found
    */
    private func findItem(name : String) -> Int {
        for i in 0..<list.count {
            let e: String = list[i]
            if e == name {
                return i
            }
        }
        return -1
    }
}
