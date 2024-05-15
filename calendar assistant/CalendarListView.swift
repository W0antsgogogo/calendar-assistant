//
//  CalendarListView.swift
//  calendar assistant
//
//  Created by 王登远 on 5/15/24.
//

import SwiftUI

struct CalendarListView: View {
    @ObservedObject var viewModel: AnniversaryViewModel
    @State private var today = Date()

    var body: some View {
            NavigationView {
                VStack {
                    CalendarView(viewModel: viewModel)
                    List {
                        // Using ForEach to wrap the list content
                        ForEach(viewModel.anniversaries.sorted(by: {
                            abs($0.date!.timeIntervalSinceNow) < abs($1.date!.timeIntervalSinceNow)
                        }), id: \.self) { anniversary in
                            VStack(alignment: .leading) {
                                Text(anniversary.name ?? "No Name")
                                Text("\(anniversary.date ?? Date(), formatter: itemFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: deleteItems) // Apply deletion here
                    }
                }
                .navigationTitle("Calendar")
            }
        }
    
    private func deleteItems(at offsets: IndexSet) {
            viewModel.deleteAnniversaryByIndex(at: offsets)
        }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()
