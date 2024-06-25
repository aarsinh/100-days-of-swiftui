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
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var rating = 3
    @State private var review = ""
    
    let genres = ["Fantasy", "Poetry", "Thriller", "Horror", "Kids", "Mystery", "Romance"]
    
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
                
                Section {
                    HStack {
                        Text("RATING")
                            .foregroundStyle(.gray)
                        Spacer()
                        RatingView(rating: $rating)
                    }
                }
                .listRowBackground(Color.clear)
                
                
                Button {
                    let newBook = Book(title: title, author: author, genre: genre, rating: rating, review: review, date:Date.now.formatted(.dateTime.year().day(.twoDigits).month(.abbreviated)))
                    
                    if validate(book: newBook) {
                        modelContext.insert(newBook)
                        dismiss()
                    } else {
                        alertMessage = "Please enter all fields"
                        showingAlert = true
                    }
                    
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
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Add New Book")
            .alert("Enter fields", isPresented: $showingAlert) { } message: {
                Text(alertMessage)
            }
        }
    }
    
    func validate(book: Book) -> Bool {
        return book.title.isNotEmpty && book.author.isNotEmpty
    }
    
}
#Preview {
    AddView()
}

