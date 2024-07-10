//
//  SortableProspectView.swift
//  Hot Propsects
//
//  Created by Aarav Sinha on 10/07/24.
//

import SwiftUI

struct SortPropspects: View {
    let filter: ProspectsView.FilterType
    @State private var sortOrder = [SortDescriptor(\Prospect.name)]
    @State private var searchBy = ""
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted"
        case .uncontacted:
            "Uncontacted"
        }
    }
    
    var body: some View {
        NavigationStack {
            ProspectsView(filter: filter, sortOrder: sortOrder, searchBy: searchBy)
                .searchable(text: $searchBy,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: Text("Search by name"))
                .navigationTitle(title)
                .toolbar {
                    Menu("Sort options", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by Name")
                                .tag([SortDescriptor(\Prospect.name)])
                            Text("Sort by Date Added")
                                .tag([SortDescriptor(\Prospect.dateAdded)])
                        }
                    }
                }
            
        }
        
    }
}

#Preview {
    SortPropspects(filter: .none)
}
