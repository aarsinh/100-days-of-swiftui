//
//  File.swift
//  Bookworm
//
//  Created by Aarav Sinha on 20/06/24.
//

import Foundation
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var rating: Int
    var review: String
    var date: String
    
    init(title: String, author: String, genre: String, rating: Int, review: String, date: String) {
        self.title = title
        self.author = author
        self.genre = genre
        self.rating = rating
        self.review = review
        self.date = date    
    }
}
