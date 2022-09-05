//
//  Endpoints.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 02/09/22.
//

import Foundation

enum Endpoints {
    case characters(offset: String)
    
    var queryParams: [URLQueryItem] {
        let commonRequest = APIRequest()
        var queryParams = [URLQueryItem(name: "ts", value: commonRequest.ts), URLQueryItem(name: "apikey", value: commonRequest.apikey), URLQueryItem(name: "hash", value: commonRequest.hash) ]
        switch self {
        case .characters(let offset):
             queryParams.append(URLQueryItem(name: "offset", value: offset))
        }
        return queryParams
    }
    
    var path: String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "gateway.marvel.com"
        components.path = path
        components.queryItems = queryParams
        return components.url
    }
}

