//
//  Bundle-Decodable.swift
//  SnowSeeker
//
//  Created by Aarav Sinha on 20/07/24.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find file: \(file)")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load data from file: \(file)")
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Could not decode file \(file) from bundle due to missing \(type) value: \(context.debugDescription)")
        } catch DecodingError.keyNotFound(let key, let context){
            fatalError("Could not decode file \(file) from bundle due to missing key: '\(key.stringValue)' - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Could not decode file '\(file)' from bundle because it appears to be invalid JSON")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode file '\(file)' from bundle due to type mismatch: \(context.debugDescription)")
        } catch {
            fatalError("Failed to decode file: \(error)")
        }
    }
}
