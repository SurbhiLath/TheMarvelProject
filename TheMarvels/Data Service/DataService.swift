//
//  DataService.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 01/09/22.
//

import Foundation


class DataService {}

extension DataService: DataServiceProtocol {
    
    /// Fetches the available marvels
    ///
    /// - Parameters:
    ///     - completion: Closure for completion notification
    func fetchMarvels(offset: Int, completion: @escaping MarvelFetchCompletion) {
        APIManager.shared.load(for: .characters(offset: "\(offset)"), with: [:], type: [Marvel].self) { result in
            switch result {
            case .success(let response):
                completion(response.data.results, nil)
            case.failure(let error):
                completion(nil, error)
            }
        }
    }
}
