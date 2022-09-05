//
//  APIResponse.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 05/09/22.
//

import Foundation

// Response struct for api response
struct APIResponse<D : Decodable>: Decodable {
    let responseCode: Int
    let status: String
    let data: APIData<D>

    enum CodingKeys: String, CodingKey {
        case responseCode = "code", data, status
    }
}

struct APIData<D: Decodable>: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: D
}
