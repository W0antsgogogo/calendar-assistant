//
//  EventKitManager.swift
//  calendar assistant
//
//  Created by 王登远 on 5/15/24.
//

import Foundation
import EventKit
import EventKitUI
class EventKitManager {
    static let shared = EventKitManager()
    let eventStore = EKEventStore()

    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }

    func fetchAnniversaries(completion: @escaping ([EKEvent]) -> Void) {
        requestAccess { granted, error in
            if granted, error == nil {
                let calendars = self.eventStore.calendars(for: .event)
                let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
                let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
                let predicate = self.eventStore.predicateForEvents(withStart: oneYearAgo, end: oneYearFromNow, calendars: calendars)
                
                let events = self.eventStore.events(matching: predicate).filter { $0.title.lowercased().contains("anniversary") }
                completion(events)
            } else {
                completion([])
            }
        }
    }
}
