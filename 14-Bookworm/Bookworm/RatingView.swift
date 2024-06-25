//
//  RatingView.swift
//  Bookworm
//
//  Created by Aarav Sinha on 21/06/24.
//

import SwiftUI

extension String {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

struct RatingView: View {
    @Binding var rating: Int
    var label = ""
    var maxRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isNotEmpty {
                Text(label)
            }
            
            ForEach(1..<maxRating + 1, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            offImage ?? onImage
        } else {
            onImage
        }
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
