//
//  AnniversaryViewModel.swift
//  calendar assistant
//
//  Created by 王登远 on 5/15/24.
//

import Foundation
import CoreData

class AnniversaryViewModel: ObservableObject {
    @Published var anniversaries: [Anniversary] = []
    private var dataStack = CoreDataStack.shared

    init() {
        fetchAnniversaries()
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange), name: NotificationCenter.dataDidChange, object: nil)
    }
    
    @objc private func contextDidChange(notification: Notification) {
        fetchAnniversaries()
    }

    private func fetchAnniversaries() {
        let request: NSFetchRequest<Anniversary> = Anniversary.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Anniversary.date, ascending: true)]

        do {
            let results = try dataStack.persistentContainer.viewContext.fetch(request)
            anniversaries = results
        } catch {
            print("Error fetching anniversaries: \(error)")
        }
    }

    func saveContext() {
        dataStack.save()
    }

    func deleteAnniversary(_ anniversary: Anniversary) {
        dataStack.delete(item: anniversary)
    }
    
    func deleteAnniversaryByIndex(at offsets: IndexSet) {
           for index in offsets {
               let anniversary = anniversaries[index]
               dataStack.persistentContainer.viewContext.delete(anniversary)
           }

           do {
               try dataStack.persistentContainer.viewContext.save()
               fetchAnniversaries() // Refresh the data
           } catch {
               print("Error when trying to delete the anniversary: \(error)")
           }
       }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
