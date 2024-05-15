//
//  calendar_assistantApp.swift
//  calendar assistant
//
//  Created by 王登远 on 5/15/24.
//

import SwiftUI

@main
struct calendar_assistantApp: App {
    // Create an observable instance of the Core Data stack.
        @StateObject private var coreDataStack = CoreDataStack.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Inject the persistent container's managed object context
                        // into the environment.
                            .environment(\.managedObjectContext,
                                          coreDataStack.persistentContainer.viewContext)
        }
    }
}
