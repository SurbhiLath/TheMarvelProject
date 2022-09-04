//
//  Comics.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 04/09/22.
//

import Foundation

// MARK: - Comic
struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let items: [Item]
    let returned: Int
}

// MARK: - Item
struct Item: Codable {
    let resourceURI: String
    let name: String
}
