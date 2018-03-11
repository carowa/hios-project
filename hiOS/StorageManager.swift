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
    let persistentContainer: NSPersistentContainer!
    // Background thread to commit changes on
    lazy var backgroundContext: NSManagedObjectContext = {
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
     
     - Parameter favorite: `FavoriteItem` to insert to persistent container
    */
    func insert(favorite: FavoriteItem) {
        backgroundContext.insert(favorite)
    }
    
    /**
     Checks if the persistent container contains the specified favorite item
     
     - Parameter favorite: `FavoriteItem` to check
     - Returns: true if the persistent container contains the favorite item, false otherwise
    */
    func contains(favorite: FavoriteItem) -> Bool {
        guard let _ = try? backgroundContext.existingObject(with: favorite.objectID) else {
            return false
        }
        return true
    }
    
    /**
     Removes a favorite item
     
     - Parameter favorite: `FavoriteItem` to remove
    */
    func remove(favorite: FavoriteItem) {
        // Check object existence first
        if contains(favorite: favorite) {
            // Grab and delete object
            let obj = backgroundContext.object(with: favorite.objectID)
            backgroundContext.delete(obj)
        }
    }
    
    /**
     Gets all added favorites from the persistent container.
     
     - Returns: Array of `FavoriteItems` contained in the persistent container.
    */
    func fetchAllFavorites() -> [FavoriteItem] {
        let request: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
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
