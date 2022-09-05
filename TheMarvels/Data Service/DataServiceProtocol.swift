//
//  DataServiceProtocol.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 01/09/22.
//

import Foundation


typealias MarvelFetchCompletion = ([Marvel]?, Error?) -> Void

protocol DataServiceProtocol {
    /// Fetches the available marvels
    ///
    /// - Parameters:
    ///     - completion: Closure for completion notification
    func fetchMarvels(offset: Int, completion: @escaping MarvelFetchCompletion)
}
