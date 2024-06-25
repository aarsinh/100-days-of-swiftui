//
//  ContentView.swift
//  Bookworm
//
//  Created by Aarav Sinha on 20/06/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort:[
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.rating)
    ]) var books: [Book]
    
    @State private var showingAddScreen = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.title)
                            
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .foregroundStyle(book.rating == 1 ? .red : Color.primary)
                                    .font(.headline)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("add view", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
            }
            .sheet(isPresented: $showingAddScreen, content: {
                    AddView()
            })
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
}
