//
//  AddView.swift
//  Bookworm
//
//  Created by Aarav Sinha on 20/06/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var rating = -1
    @State private var review = ""
    
    let genres = ["Fantasy", "Crime", "Thriller", "Horror", "Kids", "Mystery", "Romance"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Book Details") {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                    
                }
                
                Section("Review") {
                    TextEditor(text: $review)
                }
                
                Section("Rating") {
                    Picker("rating", selection: $rating) {
                        ForEach(1..<6) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Button {
                    let newBook = Book(title: title, author: author, genre: genre, rating: rating, review: review)
                    modelContext.insert(newBook)
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Save")
                            .foregroundStyle(.white)
                            .font(.headline)
                        Spacer()
                    }
                        
                }
                .frame(height: 50)
                .background(.blue)
                .clipShape(.rect(cornerRadius: 10))
                .listRowBackground(Color.clear)
            }
        }
    }
}

#Preview {
    AddView()
}
