//
//  CharacterDetailsViewModel.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 04/09/22.
//

import Foundation

class CharacterDetailsViewModel: NSObject {
    var character: Marvel
    
    init(character: Marvel) {
        self.character = character
    }
    
    var name: String {
        return character.name
    }
    
    var comics: [Item] {
        return character.comics.items
    }
    
    var comicsCount: Int {
        return comics.count > 5 ? 5 : comics.count
    }
    var characterDescription: String {
        return character.description.count > 0 ? character.description : "A character with immense power and something to do with radioactivity."
    }
    
    var thumbnail: URL? {
        return URL(string: character.thumbnail.imageURL)
    }
    
    func getComic(for indexPath: IndexPath) -> Item {
        return comics[indexPath.row]
    }
}
