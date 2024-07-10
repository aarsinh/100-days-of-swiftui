//
//  EditView.swift
//  Hot Propsects
//
//  Created by Aarav Sinha on 09/07/24.
//

import SwiftUI

struct EditView: View {
    @Bindable var prospect: Prospect
    
    var body: some View {
        NavigationStack {
            VStack {
                Section {
                    TextField("Name", text: $prospect.name)
                    TextField("Email", text: $prospect.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                .padding(.vertical, 6)
                .customBorder()
                .textFieldStyle(.roundedBorder)
                
                Toggle("Contacted", isOn: $prospect.isContacted)
            }
            .padding(.horizontal)
            
            Spacer()
                .navigationBarTitle("Edit", displayMode: .inline)
        }
    }
}

#Preview {
    EditView(prospect: .example)
}
