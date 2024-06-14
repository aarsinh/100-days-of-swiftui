//
//  ContentView.swift
//  12-HabiTracker
//
//  Created by Aarav Sinha on 13/06/24.
//

import SwiftUI
import Observation

struct Activity: Codable, Identifiable {
    var id = UUID()
    let name: String
    let description: String
    
    var completedTimes: Int = 0 {
        didSet {
            if completedTimes < 0 {
                completedTimes = 0
            }
        }
    }
}

@Observable
class Activities {
    var items = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    func update(activity: Activity) {
        guard let index = returnIndex(activity: activity) else { return }
        items[index] = activity
    }
    
    private func returnIndex(activity: Activity) -> Int? {
        return items.firstIndex(where: { $0.id == activity.id })
    }
    
    init() {
        if let savedActivities = UserDefaults.standard.data(forKey: "Activities") {
            if let decoded = try? JSONDecoder().decode([Activity].self, from: savedActivities) {
                items = decoded
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var sheetPresented = false
    @State private var activities = Activities()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities.items) { item in
                    NavigationLink() {
                        EditView(activity: item, activities: activities)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(item.name)")
                                .padding(.bottom, 2)
                            Text("\(item.description)")
                                .foregroundStyle(.white.opacity(0.5))
                                .padding(.bottom, 2)
                            Text("^[Completed \(item.completedTimes) times](inflect:true)")
                                .foregroundStyle(item.completedTimes == 0 ? .red :.green)
                        }
                    }
                    
                }
                .onDelete(perform: removeItems)
            }
                .navigationTitle("Habits")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("add activity", systemImage: "plus") {
                            sheetPresented = true
                        }
                        .sheet(isPresented: $sheetPresented) {
                            AddView(activities: activities)
                        }
                    }
                }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        activities.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
