//
//  AddAnniversaryView.swift
//  calendar assistant
//
//  Created by 王登远 on 5/15/24.
//

import SwiftUI

struct AddAnniversaryView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: AnniversaryViewModel
    
    @State private var name: String = ""
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Anniversary Name", text: $name)
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                
                Button("Save") {
                    saveAnniversary()
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("New Anniversary")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func saveAnniversary() {
        let newAnniversary = Anniversary(context: viewContext)
        newAnniversary.name = name
        newAnniversary.date = selectedDate
        viewModel.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
}
