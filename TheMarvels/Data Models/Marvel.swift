//
//  Marvel.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 01/09/22.
//

import Foundation

// MARK: - Marvel
class Marvel: Codable {
    var id: Int
    var name: String
    var resourceURI: String
    var description: String
    var thumbnail: Thumbnail
    var comics: Comics
    var isBookmarked: Bool {
            let bookmarked = UserDefaults.standard.bool(forKey: "\(id)")
            return bookmarked
    }
    
    func bookmark() {
           UserDefaults.standard.set(!isBookmarked, forKey: "\(id)")
    }
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    var path: String
    var fileExtension: String
    var imageURL: String {
        return "\(path).\(fileExtension)"
    }
    
    enum CodingKeys: String, CodingKey {
        case fileExtension = "extension", path
    }
}
