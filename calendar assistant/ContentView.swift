//
//  ContentView.swift
//  calendar assistant
//
//  Created by 王登远 on 5/15/24.
//
import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AnniversaryViewModel()
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            CalendarListView(viewModel: viewModel)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
