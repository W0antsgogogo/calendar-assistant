//
//  HomeView.swift
//  calendar assistant
//
//  Created by 王登远 on 5/15/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AnniversaryViewModel
    @State private var showingAddAnniversary = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Next Closest Anniversary")
                    .font(.title)
                    .padding()

                if let nextAnniversary = viewModel.anniversaries.first {
                    VStack {
                        Text(nextAnniversary.name ?? "No Name")
                        Text("\(nextAnniversary.date ?? Date(), formatter: itemFormatter)")
                            .font(.headline)
                            .padding()
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                } else {
                    Text("No upcoming anniversaries")
                        .padding()
                }

                Spacer()

                Button("Add New Anniversary") {
                    showingAddAnniversary = true
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)

                Spacer()
            }
            .navigationTitle("Home")
            .sheet(isPresented: $showingAddAnniversary) {
                AddAnniversaryView(viewModel: viewModel)
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()
