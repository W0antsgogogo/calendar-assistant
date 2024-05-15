//
//  CodeDataStack.swift
//  calendar assistant
//
//  Created by 王登远 on 5/15/24.
//

import CoreData

// Define an observable class to encapsulate all Core Data-related functionality.
class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "DataModel")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
        
    private init() { }
}

extension NotificationCenter {
    static let dataDidChange = Notification.Name("CoreDataStackDataDidChange")
}

extension CoreDataStack {
    // Add a convenience method to commit changes to the store.
    func save() {
        let _ = print("CoreDataStack.save called")
        // Verify that the context has uncommitted changes.
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            // Attempt to save changes.
            let _ = print("CoreDataStack.save try save")
            try persistentContainer.viewContext.save()
            NotificationCenter.default.post(name: NotificationCenter.dataDidChange, object: nil)
        } catch {
            // Handle the error appropriately.
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func delete(item: Anniversary) {
        persistentContainer.viewContext.delete(item)
        save()
    }
}


