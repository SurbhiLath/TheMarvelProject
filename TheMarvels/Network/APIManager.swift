//
//  APIManager.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 02/09/22.
//

import Foundation
import CommonCrypto

class APIManager {
   
    public static let shared = APIManager()
    private init() {}
    
    func load<T : Decodable>(
        for endPoint: Endpoints,
        type: T.Type,
        withCompletion completion: @escaping (Result<APIResponse<T>, Error>) -> Void
    ) {
        let requestParameters = APIRequest()
        let url = URL(string: "\(MarvelURLs.baseURL + endPoint.rawValue)?ts=\(requestParameters.ts)&apikey=\(requestParameters.apikey)&hash=\(requestParameters.hash)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            
            do {
                let response = try JSONDecoder().decode(APIResponse<T>.self, from: data!)
                DispatchQueue.main.async { completion(.success(response)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
        task.resume()
    }
}

struct APIRequest: Encodable {
    let ts: String = "\(Date().timeIntervalSince1970)".components(separatedBy: ".")[0]
    let apikey: String = "8aea06385d17ce44ee52d3ebcd124a69"
    var hash: String {
        var hashString = ""
        if let privateApiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            let combination = ts+privateApiKey+apikey
            hashString = MD5(combination) ?? ""
        }
        return hashString
    }
    
    // Encryption for api request
    func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: .utf8) {
            _ = d.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
                return ""
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}

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
