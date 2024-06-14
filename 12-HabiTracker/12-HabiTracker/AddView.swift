//
//  AddView.swift
//  12-HabiTracker
//
//  Created by Aarav Sinha on 13/06/24.
//

import SwiftUI

struct AddView: View {
    var activities: Activities
    @State private var activity = ""
    @State private var description = ""
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Activity", text: $activity)
                TextField("Description", text: $description)
            }
                .navigationBarTitle("Add an activity")
                .toolbar {
                    Button("Save") {
                        let item = Activity(name: activity, description: description)
                        activities.items.append(item)
                        dismiss()
                    }
                }
        }
    }
}

#Preview {
    return AddView(activities: Activities())
        .preferredColorScheme(.dark)
}
