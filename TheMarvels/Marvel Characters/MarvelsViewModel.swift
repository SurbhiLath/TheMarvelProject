//
//  MarvelsViewModel.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 01/09/22.
//

import Foundation

protocol MarvelsViewModelProtocol: NSObject {
    func updateMarvels()
    func loadingData()
    func failedToFetchMarvels()
}

class MarvelsViewModel: NSObject {
    private var marvelCharacters = [Marvel]()
    private var dataService: DataServiceProtocol
    weak var delegate: MarvelsViewModelProtocol?
    private let userDefaults = UserDefaults.standard
    private static let marvelsCacheKey = "veletio.TheMarvels.marvelsCacheKey"
    var isSearching: Bool = false
    var filteredMarvels = [Marvel]()
    init(dataService: DataServiceProtocol = DataService(), delegate: MarvelsViewModelProtocol) {
        self.dataService = dataService
        self.delegate = delegate
        super.init()
        fetchMarvels()
    }
    
    var numberOfCharacters: Int {
        return isSearching ? filteredMarvels.count : marvelCharacters.count
    }
    
    func cellViewModel(for indexpath: IndexPath) -> MarvelTableCellViewModel {
        let character = isSearching ? filteredMarvels[indexpath.row] : marvelCharacters[indexpath.row]
        return MarvelTableCellViewModel(character: character)
    }
    
    func character(for indexpath: IndexPath) -> Marvel {
        let character = isSearching ? filteredMarvels[indexpath.row] : marvelCharacters[indexpath.row]
        return character
    }
    
    func search(for text: String) {
        filteredMarvels = marvelCharacters.filter { $0.name.lowercased().contains(text.lowercased()) }
        if(filteredMarvels.count == 0){
//            isSearching = false
//            filteredMarvels = marvelCharacters
        } else {
            isSearching = true
        }
    }
    
    // Fetches the available marvels from either local if available or from the sevrer
    private func fetchMarvels() {
        if let marvels = try? userDefaults.getObject(forKey: Self.marvelsCacheKey, castTo: [Marvel].self) {
            self.marvelCharacters = marvels
            self.filteredMarvels = marvels
            self.delegate?.updateMarvels()
        } else {
            fetchFromServer()
        }
    }
    
    // Fetches the available marvels from server on pull refresh
    func reloadMarvels() {
        fetchFromServer()
    }
    
    func fetchFromServer() {
        delegate?.loadingData()
        dataService.fetchMarvels { marvels, error in
            if let error = error {
                self.delegate?.failedToFetchMarvels()
                print("Failed to fetch marvels with error. Error \(error.localizedDescription)")
                return
            }
            
            if let marvels = marvels {
                self.marvelCharacters = marvels
                self.filteredMarvels = marvels
                self.delegate?.updateMarvels()
                do {
                    try self.userDefaults.setObject(marvels, forKey: Self.marvelsCacheKey)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
