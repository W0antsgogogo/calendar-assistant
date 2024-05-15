//
//  SwiftUIView.swift
//  calendar assistant
//
//  Created by 王登远 on 5/15/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: AnniversaryViewModel
    @State private var currentDate = Date()

    var body: some View {
        VStack {
            calendarHeader
            daysOfWeekHeader
            calendarGrid
        }
        .padding()
    }

    private var calendarHeader: some View {
        HStack {
            Button(action: { self.changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text("\(currentDate, formatter: monthFormatter)")
                .font(.title)
            Spacer()
            Button(action: { self.changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
            }
        }
    }

    private var daysOfWeekHeader: some View {
        HStack {
            ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var calendarGrid: some View {
        let days = generateDaysInMonth(currentDate)
        // Compute the offsets for the first row, where the month starts
        var firstDayOffset: Int {
            guard let firstDate = days.first else { return 0 }
            return Calendar.current.component(.weekday, from: firstDate) - 1 // Adjust by -1 for zero indexing
        }
        
        
        // Generate grid for the dates
        let gridRows = Array(repeating: GridItem(.flexible()), count: 6) // Up to 6 rows in a month
        return LazyVGrid(columns: gridRows) {
            // Empty views for the offset at the beginning of the first row
            ForEach(0..<firstDayOffset, id: \.self) { _ in
                Text("")
                    .frame(height: 50)
            }
            
            // Views for each date
            ForEach(days, id: \.self) { date in
                Text("\(Calendar.current.component(.day, from: date))")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background(viewModel.anniversaries.contains(where: { Calendar.current.isDate($0.date!, inSameDayAs: date) }) ? Color.blue : Color.clear)
                    .cornerRadius(8)
            }
        }
    }

    private func generateDaysInMonth(_ date: Date) -> [Date] {
        var days = [Date]()
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!

        for day in range {
            if let dateToAdd = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(dateToAdd)
            }
        }
        return days
    }

    private func changeMonth(by months: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: months, to: currentDate) {
            currentDate = newDate
        }
    }
}

private let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
}()
