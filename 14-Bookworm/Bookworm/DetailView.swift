//
//  DetailView.swift
//  Bookworm
//
//  Created by Aarav Sinha on 21/06/24.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    let book: Book
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre)
                        .resizable()
                        .scaledToFit()
                    
                    Text(book.genre.uppercased())
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.75))
                        .clipShape(.rect(cornerRadius: 10))
                        .offset(x: -5, y: -5)
                }
                Text(book.author)
                    .font(.title)
                    .foregroundStyle(.secondary)
                
                Text(book.date)
                    .italic()
                    .foregroundStyle(.secondary)
                
                Text(book.review)
                    .padding()
                
                RatingView(rating: .constant(book.rating))
                    .font(.title)
            }
            .alert("Delete book", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive, action: deleteBook)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure?")
            }
            .navigationBarTitle(book.title, displayMode: .inline)
            .scrollBounceBehavior(.basedOnSize)
            .toolbar {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
                .accessibilityLabel(Text("Delete this book"))
                
            }
        }
    }
    
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(title: "Test", author: "Test", genre: "Test", rating: 3, review: "Test", 
                           date: Date.now.formatted(.dateTime.year().day(.twoDigits).month(.abbreviated)))
        
        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
