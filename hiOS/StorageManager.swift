//
//  StorageManager.swift
//  hiOS
//
//  Created by Justin Inouye on 3/9/18.
//  Copyright © 2018 Keertana Chandar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Manages storing persistent data
class StorageManager {
    // Shared object
    static let shared = StorageManager()
    // Encapsulation of the Core Data stack
    private let persistentContainer: NSPersistentContainer!
    // Background thread to commit changes on
    private lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    /// Initializes a StorageManager for managing persistent data
    init() {
        // Grab current AppDelegate. This is needed so fail if we cannot.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.persistentContainer = appDelegate.persistentContainer
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    /**
     Inserts a favorite item into the persistent container.
     
     - Parameter favoriteWithName: Name of a `FavoriteItem` to insert to persistent container
    */
    func insert(favoriteWithName: String) {
        // Create a new FavoriteItem and grab a ref to it to edit
        guard let favItem = NSEntityDescription.insertNewObject(forEntityName: "FavoriteItem", into: backgroundContext) as? FavoriteItem else { return }
        favItem.name = favoriteWithName
        // Insert to our persistent container
        backgroundContext.insert(favItem)
    }
    
    /**
     Checks if the persistent container contains the specified favorite name
     
     - Parameter favoriteWithName: Favorite name to check
     - Returns: true if the persistent container contains the favorite item, false otherwise
    */
    func contains(favoriteWithName: String) -> Bool {
        // Create a fetch request with a filter to search for given name
        let favFetch = NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
        favFetch.predicate = NSPredicate(format: "name == %@", favoriteWithName)
        // Attempt to fetch the FavoriteItem from the persistent container
        let result = try? backgroundContext.fetch(favFetch)
        // The result will be an error or an Array of FavoriteItems
        guard let resultCount: Int = result?.count else {
            return false
        }
        return resultCount > 0
    }
    
    /**
     Removes a favorite item
     
     - Parameter favoriteWithName: Name of `FavoriteItem` to remove
    */
    func remove(favoriteWithName: String) {
        // Check object existence first with a name filter
        let favFetch = NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
        favFetch.predicate = NSPredicate(format: "name == %@", favoriteWithName)
        let result = try? backgroundContext.fetch(favFetch)
        guard let resultCount: Int = result?.count else {
            return
        }
        // Remove it if it exists
        if resultCount > 0 {
            backgroundContext.delete(result![0])
        }
    }
    
    /**
     Gets all added favorites from the persistent container.
     
     - Returns: Array of `FavoriteItems` contained in the persistent container.
    */
    func fetchAllFavorites() -> [FavoriteItem] {
        let request: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        let results = try? backgroundContext.fetch(request)
        return results ?? [FavoriteItem]()
    }
    
    /**
     Explicitly saves changes to the persistent store
    */
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("StorageManager save error: \(error)")
            }
        }
        
    }
}
