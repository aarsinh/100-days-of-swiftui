//
//  EditView.swift
//  12-HabiTracker
//
//  Created by Aarav Sinha on 13/06/24.
//

import SwiftUI

struct EditView: View {
    var activity: Activity
    var activities: Activities
    var body: some View {
        NavigationStack {
            Form {
                Text(activity.name)
                Text(activity.description)
                Stepper(label: { Text("^[Completed \(activity.completedTimes) times](inflect: true)")
                    .foregroundStyle(activity.completedTimes == 0 ? .red : .green)}, 
                        onIncrement: { updateActivity(by: 1) },
                        onDecrement: { updateActivity(by: -1) })
            }
            .navigationTitle("Edit Activity")
        }
    }
    
    func updateActivity(by change: Int) {
        var activity = self.activity
        activity.completedTimes += change
        self.activities.update(activity: activity)
    }
}

#Preview {
    var activities = [Activity]()
    return EditView(activity: activities[0], activities: Activities())
        .preferredColorScheme(.dark)
}
