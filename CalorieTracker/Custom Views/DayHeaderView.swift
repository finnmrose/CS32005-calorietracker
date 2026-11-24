//
//  DayHeaderView.swift
//  CalorieTracker
//
//  Created by Rose on 17/11/2026.
//

import SwiftUI
import SwiftData

struct DayHeaderView : View {
    @Binding var day : Day
    @Environment(Log.self) private var log: Log
    
    @State var date: Date
    @State private var show_popover = false
    
    init(_ day: Binding<Day>) {
        self._day = day
        self.date = day.wrappedValue.date
    }

    var body: some View {
        VStack {
            HStack {
                Text(day.date.formatted(date: .long, time: .omitted))
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
                Button("Change Day", systemImage: "calendar") {
                    show_popover = true
                }.labelStyle(.iconOnly).buttonStyle(.bordered)
                    .overlay {
                        DatePicker(
                            "Change Day",
                            selection: $date,
                            displayedComponents: [.date]
                        ).blendMode(.destinationOver)
                            .onChange(of: date) { oldDate, newDate in
                                if log[oldDate].isEmpty() {
                                    log.data.removeValue(forKey: oldDate)
                                }
                                day = log[newDate]
                            }
                    }
            }
            Divider().hidden()
            HStack {
                ForEach(day.goals.keys.sorted(by: {$0.rawValue < $1.rawValue})) { nutrient in
                    if nutrient.rawValue > 0 { Spacer() }
                    GoalWheel(day: $day, nutrient: nutrient)
                    
                }
            }
        }
    }
}

struct GoalWheel: View {
    @Binding var day: Day
    let nutrient: Food.Nutrient
    
    var body : some View {
        let value = day.total(field: nutrient)
        let goal = day.goals[nutrient] ?? value
        
        let progress =  value / goal
        VStack {
            Text(nutrient.short_name)
            
            ZStack {
                Circle()
                    .fill(.opacity(0))
                    .stroke(.quinary, lineWidth: 10)
                    .frame(width: 60, height: 60)
                Circle()
                    .trim(from: CGFloat(1 - progress))
                    .fill(.opacity(0))
                    .stroke(nutrient.color, lineWidth: 10)
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                Text(progress.formatted(.percent.notation(.compactName).precision(.fractionLength(0))))
            }
            
            Divider().hidden()
            Text(value.formatted(UTILS.SHORT_FORMAT) + nutrient.unit)
            Text(goal.formatted(UTILS.SHORT_FORMAT) + nutrient.unit)
        }
    }
    
}
